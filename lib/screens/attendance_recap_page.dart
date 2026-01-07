import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../color.dart';
import '../services/api_service.dart';

class AttendanceRecapScreen extends StatefulWidget {
  final String sessionId;

  const AttendanceRecapScreen({super.key, required this.sessionId});

  @override
  State<AttendanceRecapScreen> createState() => _AttendanceRecapScreenState();
}

class _AttendanceRecapScreenState extends State<AttendanceRecapScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  // Data
  List<dynamic> _students = [];
  int _total = 0;
  int _hadir = 0;
  int _tidakHadir = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getSessionData(widget.sessionId);
      final students = data['students'] ?? [];

      setState(() {
        _students = students;
        _total = students.length;
        _hadir = students
            .where((s) => s['status'].toString().toLowerCase() == 'hadir')
            .length;
        _tidakHadir = _total - _hadir;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Rekap Absensi',
          style: TextStyle(
              color: AppColors.textDarkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text("Gagal memuat data: $_errorMessage"))
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Reduced top padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateStr,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text(
                          'Rekap Presensi Kehadiran Siswa',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDarkBlue,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Summary Cards
                        Row(
                          children: [
                            _SummaryBox(label: 'Total', value: '$_total'),
                            const SizedBox(width: 12),
                            _SummaryBox(label: 'Hadir', value: '$_hadir'),
                            const SizedBox(width: 12),
                            _SummaryBox(
                                label: 'Tidak hadir', value: '$_tidakHadir'),
                          ],
                        ),
                        const SizedBox(height: 25),

                        // List Container
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4))
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Daftar Siswa',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDarkBlue,
                                  ),
                                ),
                              ),
                              const Divider(height: 1, thickness: 1),
                              if (_students.isEmpty)
                                const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Center(
                                        child: Text("Tidak ada data siswa")))
                              else
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: _students.length,
                                  separatorBuilder: (_, __) =>
                                      const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final student = _students[index];
                                    final isPresent = student['status']
                                            .toString()
                                            .toLowerCase() ==
                                        'hadir';

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              student['name'] ?? 'Siswa',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color:
                                                      AppColors.textDarkBlue),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          _StatusButton(isPresent: isPresent),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDarkBlue),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final bool isPresent;

  const _StatusButton({required this.isPresent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isPresent ? AppColors.primaryBlue : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryBlue, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        isPresent ? 'Hadir' : 'Tidak hadir',
        style: TextStyle(
          color: isPresent ? Colors.white : AppColors.primaryBlue,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
