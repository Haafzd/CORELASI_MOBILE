import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import '../services/api_service.dart';
import 'attendance_recap_page.dart';
import 'widgets/mobile_scanner_view.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<StatefulWidget> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  bool _isLoading = true;
  String? _errorMessage;

  Map<String, dynamic>? _activeSession;
  Map<String, dynamic>? _sessionDetail;
  List<dynamic> _students = [];

  int _totalStudents = 0;
  int _hadirCount = 0;
  int _tidakHadirCount = 0;

  final Color primaryBlue = const Color.fromARGB(255, 0, 71, 124);
  final Color textDarkBlue = const Color.fromARGB(255, 0, 46, 110);

  @override
  void initState() {
    super.initState();
    _initializeCameras();
    _loadData();
  }

  Future<void> _initializeCameras() async {
    try {
      cameras = await availableCameras();
    } catch (e) {
      debugPrint("Camera init error: $e");
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final scheduleData = await ApiService.getTodaySchedule();
      final List rawSchedules = scheduleData['schedules'] ?? [];

      Map<String, dynamic>? targetSession;

      double timeToDouble(String time) {
        final parts = time.split(':');
        return int.parse(parts[0]) + int.parse(parts[1]) / 60.0;
      }

      final now = TimeOfDay.now();
      final nowDouble = now.hour + now.minute / 60.0;

      for (var s in rawSchedules) {
        double start = timeToDouble(s['time_start']);
        double end = timeToDouble(s['time_end']);
        if (nowDouble >= start && nowDouble <= end) {
          targetSession = s;
          break;
        }
      }

      if (targetSession == null) {
        for (var s in rawSchedules) {
          double start = timeToDouble(s['time_start']);
          if (nowDouble < start) {
            targetSession = s;
            break;
          }
        }
      }

      if (targetSession != null) {
        _activeSession = targetSession;
        final detailData =
            await ApiService.getSessionData(targetSession['id'].toString());

        _sessionDetail = detailData;
        _students = detailData['students'] ?? [];

        _totalStudents = _students.length;
        _hadirCount = _students
            .where((s) => s['status'].toString().toLowerCase() == 'hadir')
            .length;
        _tidakHadirCount = _totalStudents - _hadirCount;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  String _scanStatus = "Arahkan kamera ke QR Code NIS Siswa";
  Color _scanStatusColor = Colors.grey;
  bool _isProcessingScan = false;

  void scannerDialog() {
    _scanStatus = "Arahkan kamera ke QR Code NIS Siswa";
    _scanStatusColor = Colors.grey;
    _isProcessingScan = false;

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Scan QR Code Siswa",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textDarkBlue)),
                      IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            if (!_isProcessingScan) Navigator.of(context).pop();
                          }),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Colors.black),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Stack(
                        children: [
                          MobileScannerView(
                            onDetect: (barcode) {
                              _handleBarcode(barcode, setDialogState);
                            },
                          ),
                          if (_isProcessingScan)
                            Center(
                                child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const CircularProgressIndicator(
                                  color: Colors.white),
                            ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: _scanStatusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: _scanStatusColor.withOpacity(0.5))),
                    child: Text(_scanStatus,
                        style: TextStyle(
                            color: _scanStatusColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _handleBarcode(String? code, StateSetter setDialogState) async {
    if (code == null || _activeSession == null || _isProcessingScan) return;

    setDialogState(() {
      _isProcessingScan = true;
      _scanStatus = "Memproses...";
      _scanStatusColor = Colors.blue;
    });

    try {
      final sessionId = _activeSession!['id'].toString();

      // call API
      await ApiService.scanAttendance(sessionId, code);

      if (!mounted) return;
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Berhasil scan: $code"),
          backgroundColor: Colors.green));

      _loadData();
    } catch (e) {
      if (!mounted) return;

      setDialogState(() {
        _isProcessingScan = false; 
        _scanStatus = "Gagal: ${e.toString().replaceAll('Exception:', '')}";
        _scanStatusColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Gagal memuat data: $_errorMessage"),
              TextButton(onPressed: _loadData, child: const Text("Coba Lagi"))
            ],
          )));
    }

    if (_activeSession == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text("Kehadiran"),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0),
        bottomNavigationBar: _bottomNavBar(context),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.event_busy, size: 80, color: Colors.grey[300]),
          const Text("Tidak ada kelas aktif"),
          TextButton(onPressed: _loadData, child: const Text("Refresh"))
        ])),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Kehadiran",
                  style: TextStyle(
                      color: textDarkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
              const SizedBox(height: 6),
              Text(
                  DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                      .format(DateTime.now()),
                  style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
      ),
      bottomNavigationBar: _bottomNavBar(context),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClassInfoCard(),
              const SizedBox(height: 15),
              _buildMaterialCard(),
              const SizedBox(height: 20),
              Text("Rekap Presensi Kehadiran Siswa",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textDarkBlue)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _sumBox("$_totalStudents", "Total")),
                  const SizedBox(width: 10),
                  Expanded(child: _sumBox("$_hadirCount", "Hadir")),
                  const SizedBox(width: 10),
                  Expanded(child: _sumBox("$_tidakHadirCount", "Tidak hadir")),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: scannerDialog,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                  label: const Text("Scan QR Siswa",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
              _buildStudentList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[200]!))),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey[400],
        currentIndex: 1, // Attendance Tab
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 1) {
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 28), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner_rounded, size: 28), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded, size: 28), label: ''),
        ],
      ),
    );
  }

  Widget _buildClassInfoCard() {
    final subName = _activeSession?['subject_name'] ?? '-';
    final clsName = _activeSession?['class_name'] ?? '-';
    final timeStr =
        "${_activeSession?['time_start']} - ${_activeSession?['time_end']}";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color.fromARGB(
              255, 0, 46, 110), 
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: const Color.fromARGB(255, 0, 46, 110).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: const Text("Sedang berlangsung",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 46, 110),
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 15),

          Text(subName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(clsName,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.9), fontSize: 16)),

          const SizedBox(height: 20),
          Divider(color: Colors.white.withOpacity(0.2), height: 1),
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Waktu",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7), fontSize: 12)),
                const SizedBox(height: 4),
                Text(timeStr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15))
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text("Ruang",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7), fontSize: 12)),
                const SizedBox(height: 4),
                Text(clsName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15))
              ]),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMaterialCard() {
    final journal = _sessionDetail?['journal'];
    final topic =
        journal != null ? journal['topic'] : "Belum mengisi jurnal materi";
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Materi Hari Ini",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textDarkBlue,
                  fontSize: 16)),
          const SizedBox(height: 5),
          Text(topic, style: const TextStyle(color: Colors.grey))
        ],
      ),
    );
  }

  Widget _sumBox(String count, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(count,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Daftar Siswa",
                    style: TextStyle(
                        color: textDarkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                GestureDetector(
                  onTap: () {
                    if (_activeSession != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AttendanceRecapScreen(
                                  sessionId:
                                      _activeSession!['id'].toString())));
                    }
                  },
                  child: const Row(
                    children: [
                      Text("Lihat Detail",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight
                                  .bold)), 
                      Icon(Icons.chevron_right, size: 16, color: Colors.grey)
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 1),
          if (_students.isEmpty)
            const Padding(
                padding: EdgeInsets.all(20),
                child: Text("Belum ada data siswa",
                    style: TextStyle(color: Colors.grey)))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _students.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final student = _students[index];
                final statusRaw = student['status'].toString().toLowerCase();
                final isPresent = statusRaw == 'hadir';
                final statusLabel = isPresent ? 'Hadir' : 'Tidak Hadir';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(student['name'] ?? "Siswa",
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      Container(
                        width: 100, 
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isPresent ? primaryBlue : Colors.white,
                          border: Border.all(color: primaryBlue, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(statusLabel,
                            style: TextStyle(
                                color: isPresent ? Colors.white : primaryBlue,
                                fontSize: 12, 
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                );
              },
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
