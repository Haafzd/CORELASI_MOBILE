import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BapPage extends StatefulWidget {
  const BapPage({super.key});

  @override
  State<BapPage> createState() => _BapPageState();
}

class _BapPageState extends State<BapPage> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _materiController = TextEditingController();
  final _indikatorController =
      TextEditingController(); // Maps to observation_notes
  final _tempatController = TextEditingController();

  // State
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  // Data
  String? _sessionId;
  Map<String, dynamic>? _sessionData; // Contains subject, classroom info
  List<Map<String, dynamic>> _students = []; // List of students for attendance

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_sessionId == null) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['session_id'] != null) {
        _sessionId = args['session_id'].toString();
        _loadData();
      } else {
        // Error if no session ID
        setState(() {
          _isLoading = false;
          _errorMessage = "Session ID tidak ditemukan";
        });
      }
    }
  }

  Future<void> _loadData() async {
    try {
      final data = await ApiService.getSessionData(_sessionId!);

      setState(() {
        _sessionData = data;

        // Populate Students
        List<dynamic> rawStudents = data['students'] ?? [];
        _students = rawStudents
            .map((s) => {
                  'nis': s['nis'],
                  'name': s['name'],
                  'status': s['status'] ?? 'hadir' // Default or existing status
                })
            .toList();

        // Populate Existing Journal if any
        if (data['journal'] != null) {
          _materiController.text = data['journal']['topic'] ?? '';
          _indikatorController.text =
              data['journal']['observation_notes'] ?? '';
          _tempatController.text = data['journal']['location'] ?? '';
        } else {
          // If new, maybe set default defaults
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll("Exception: ", "");
      });
    }
  }

  Future<void> _simpanForm() async {
    if ((_formKey.currentState?.validate() ?? false) == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua field')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Construct Body
      // attendance: [ {nis:.., status:..}, ... ]
      List<Map<String, dynamic>> attendancePayload = _students
          .map((s) => {'nis': s['nis'], 'status': s['status']})
          .toList();

      Map<String, dynamic> body = {
        'topic': _materiController.text,
        'observation_notes': _indikatorController.text,
        'location': _tempatController.text,
        'attendance': attendancePayload
      };

      await ApiService.saveJournal(_sessionId!, body);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('BAP berhasil disimpan!'),
              backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Gagal menyimpan: $e'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _materiController.dispose();
    _indikatorController.dispose();
    _tempatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If loading or error
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Memuat Data...")),
        body: Center(
            child: _errorMessage != null
                ? Text(_errorMessage!,
                    style: const TextStyle(color: Colors.red))
                : const CircularProgressIndicator()),
      );
    }

    // Extract Info
    // Backend now sends top-level keys to be safe
    final subjectName = _sessionData?['subject_name'] ??
        _sessionData?['session']?['subject']?['name'] ??
        "Mata Pelajaran";
    final className = _sessionData?['classroom_name'] ??
        _sessionData?['session']?['classroom']?['name'] ??
        "Kelas";
    final date = _sessionData?['date_formatted'] ?? "";

    return Scaffold(
      backgroundColor: Colors.grey[50], // Lighter background
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: Navigator.of(context).pop,
        ),
        title: const Text(
          "Berita Acara Pertemuan",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER CARD ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 46, 110), // Primary Blue (Matches Home)
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 0, 46, 110).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        subjectName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.2))
                        ),
                        child: Text(
                          '$className • $date',
                          style: const TextStyle(
                              color: Colors.white, 
                              fontSize: 13,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                const Text('Detail Pertemuan',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 15),

                // --- FORM FIELDS ---
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2))
                    ],
                    border: Border.all(color: Colors.grey[100]!),
                  ),
                  child: Column(
                    children: [
                      _buildTextFormField(
                        controller: _materiController,
                        labelText: 'Topik / Materi Pembelajaran',
                        hintText: 'Contoh: Aljabar Linear',
                        icon: Icons.menu_book_rounded,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _indikatorController,
                        labelText: 'Catatan KBM',
                        hintText: 'Contoh: Siswa aktif berdiskusi...',
                        icon: Icons.note_alt_outlined,
                        maxLines: 3,
                        isRequired: false,
                      ),
                      const SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _tempatController,
                        labelText: 'Lokasi / Kelas KBM',
                        hintText: 'Contoh: Lab Komputer',
                        icon: Icons.location_on_outlined,
                        isRequired: false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // --- ACTION BUTTON ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _simpanForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 46, 110),
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shadowColor: const Color.fromARGB(255, 0, 46, 110).withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.save_rounded),
                              SizedBox(width: 8),
                              Text('SIMPAN BAP',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          )),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          textAlignVertical: TextAlignVertical.top, // Fix text position
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 0), // Adjust if needed
              child: Icon(icon, color: Colors.grey[400], size: 20),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 0, 46, 110), width: 1.5),
            ),
          ),
          validator: (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return '$labelText wajib diisi';
            }
            return null;
          },
        ),
      ],
    );
  }
}
