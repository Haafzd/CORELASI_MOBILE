import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.9:8000/api/mobile";

  // --- LOGIN ---
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'}, 
        body: {
          'email': email,
          'password': password,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
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

  // --- GET USER DATA  ---
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

    // Kirim NIP sebagai query param 
    final url = Uri.parse('$baseUrl/schedule?nip=${user['nip']}');

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return data; 
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
    try {
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
    final now = DateTime.now();
    final dateStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
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
