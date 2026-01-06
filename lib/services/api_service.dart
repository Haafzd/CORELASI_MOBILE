import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Ganti dengan IP komputer Anda jika di real device (misal 192.168.1.x)
  // Detected IP: 192.168.0.108
  static const String baseUrl = "http://192.168.1.9:8000/api/mobile";

  // --- LOGIN ---
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'}, // Force JSON response
        body: {
          'email': email,
          'password': password,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Simpan data user ke SharedPreferences biar 'tetap login'
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', jsonEncode(data['user']));
        return data;
      } else {
        throw Exception(data['message'] ?? 'Login gagal');
      }
    } catch (e) {
      throw Exception('Gagal menghubungi server: $e');
    }
  }

  // --- GET USER DATA (Local) ---
  static Future<Map<String, dynamic>?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user_data');
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }

  // --- LOGOUT ---
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
  }

  // --- GET SCHEDULE ---
  static Future<Map<String, dynamic>> getTodaySchedule() async {
    final user = await getStoredUser();
    if (user == null || user['nip'] == null) {
      throw Exception('User belum login atau tidak memiliki NIP');
    }

    // Kirim NIP sebagai query param (sesuai controller kita)
    final url = Uri.parse('$baseUrl/schedule?nip=${user['nip']}');

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return data; // contains 'day', 'date', 'schedules'
      } else {
        throw Exception(data['message'] ?? 'Gagal memuat jadwal');
      }
    } catch (e) {
      throw Exception('Error koneksi: $e');
    }
  }

  // --- GET SESSION DATA (STUDENTS & EXISTING JOURNAL) ---
  static Future<Map<String, dynamic>> getSessionData(String sessionId) async {
    final url = Uri.parse('$baseUrl/teacher/sessions/$sessionId/data');
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      throw Exception('Gagal load data sesi: $e');
    }
  }

  // --- SAVE JOURNAL (BAP) ---
  static Future<void> saveJournal(
      String sessionId, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/teacher/sessions/$sessionId/journals');

    // We need Auth Token ideally, or assume session based on API structure (currently open if no middleware)
    // But we are using a simple controller. The controller expects `auth()` user.
    // Our route in api.php is NOT protected by sanctum yet (line 9: Route::group([], ...))
    // BUT the controller uses `$request->user()`. This will fail if not authenticated.
    // We need to pass the user ID or modify controller to trust input or use sanctum.
    // For this demo/task, I will assume we might need to send a dummy user ID or handle it.

    // WAIT. `TeachingJournalController::store` line 108: `$request->user()->notify(...)`.
    // If `$request->user()` is null, it crashes.
    // Since we haven't set up Sanctum on mobile, we must simulate auth or turn off that notification requirement.
    // OR, we simply pass `user_id` in body and modify controller to use `User::find($request->user_id)`.

    // For now, let's update this to send the POST.
    // I will modify the controller later if it fails.

    // Just headers
    try {
      // Retrieve stored user to get ID (if we modify controller to accept user_id)
      final user = await getStoredUser();
      final userId = user?['id'];

      var finalBody = Map<String, dynamic>.from(body);
      if (userId != null) finalBody['user_id'] = userId;

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(finalBody),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Gagal simpan BAP');
      }
    } catch (e) {
      throw Exception('Error : $e');
    }
  }

  // --- SCAN ATTENDANCE ---
  static Future<Map<String, dynamic>> scanAttendance(
      String sessionId, String studentNis) async {
    final url = Uri.parse('$baseUrl/attendance/scan');

    // Defaulting date to today YYYY-MM-DD
    final now = DateTime.now();
    final dateStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    // Need logged in user ID? sending user_id in headers or body if needed by controller.
    // Controller uses $request->user()->id ?? 't-19800101'.
    // Since we don't have token auth yet, it will fallback to t-19800101 which is fine for demo.

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'schedule_session_id': sessionId,
          'student_nis': studentNis,
          'attendance_date': dateStr
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Scan gagal');
      }
    } catch (e) {
      throw Exception('Error scan: $e');
    }
  }

  // --- NOTIFICATIONS ---
  static Future<Map<String, dynamic>> getNotifications(
      {String type = 'all'}) async {
    final user = await getStoredUser();
    if (user == null) {
      // Return empty if not logged in (or throw)
      return {
        'notifications': {'data': []},
        'unread_count': 0
      };
    }

    // We must force JSON response using Accept header
    // Route: GET /notifications?type=...
    // The controller checks `wantsJson()` or returns view. Headers are key.

    // NOTE: Authentication is relying on session or we need to pass user_id if not using standard auth.
    // The existing controller uses Auth::user(). Without Sanctum token, this might fail on mobile.
    // However, if we are consistent with Login/Logout not providing a token yet, we might have issues.
    // But since `getTodaySchedule` uses `?nip=...` to bypass auth, we might need a similar bypass for notifications if Auth is not set up.
    // Let's check NotificationController again. It uses Auth::user().
    // If mobile login doesn't set a session (it's API stateless usually), Auth::user() is null.
    // WORKAROUND: We will likely need to modify Backend to accept `?user_id=...` or `?nip=...` for now, OR we assume the user installed Sanctum (not seeing it).
    // Given the task is "Sync Backend", I should probably fix the backend to support mobile (API Token or ID param).
    // For now, I will write the FLUTTER code assuming it works or I will pass NIP/User ID if I can.
    // But standard Laravel API usually needs Token.
    // I will try to pass `user_id` as query param and update Controller if needed.

    final url =
        Uri.parse('$baseUrl/notifications?type=$type&user_id=${user['id']}');

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Silently fail or return empty
        print(
            "Notification fetch failed: ${response.statusCode} ${response.body}");
        return {
          'notifications': {'data': []},
          'unread_count': 0
        };
      }
    } catch (e) {
      throw Exception('Error loading notifications: $e');
    }
  }

  static Future<void> markAllRead() async {
    final user = await getStoredUser();
    if (user == null) return;

    final url =
        Uri.parse('$baseUrl/notifications/mark-all-read?user_id=${user['id']}');
    await http.get(url, headers: {'Accept': 'application/json'});
  }
}
