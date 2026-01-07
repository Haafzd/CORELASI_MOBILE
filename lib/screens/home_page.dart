import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/subject_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> _scheduleFuture;
  String _userName = "Guru";
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadUnreadCount();
    _scheduleFuture = ApiService.getTodaySchedule();
  }

  Future<void> _loadUnreadCount() async {
    try {
      final res = await ApiService.getNotifications();
      if (mounted) {
        setState(() {
          _unreadCount = res['unread_count'] ?? 0;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadUser() async {
    final user = await ApiService.getStoredUser();
    if (user != null) {
      setState(() {
        _userName = user['name'] ?? "Guru";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomNavBar(context),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _scheduleFuture,
          builder: (context, snapshot) {
            // Handle Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Handle Error
            if (snapshot.hasError) {
              return Center(child: Text("Gagal memuat: ${snapshot.error}"));
            }

            // Data Processing
            final data = snapshot.data;
            List<dynamic> rawSchedules = data?['schedules'] ?? [];
            List<SubjectModel> subjects = [];

            // Calculate Status Time
            final now = TimeOfDay.now();

            final nowDouble = now.hour + now.minute / 60.0;

            for (var item in rawSchedules) {
              // Parse basic data
              var subject = SubjectModel.fromApi(item);
              // Calculate logic status
              try {
                final startParts = item['time_start'].split(':');
                final endParts = item['time_end'].split(':');
                final startH = int.parse(startParts[0]);
                final startM = int.parse(startParts[1]);
                final endH = int.parse(endParts[0]);
                final endM = int.parse(endParts[1]);

                final startDouble = startH + startM / 60.0;
                final endDouble = endH + endM / 60.0;

                String calcStatus = 'upcoming';
                if (nowDouble >= startDouble && nowDouble <= endDouble) {
                  calcStatus = 'ongoing';
                } else if (nowDouble > endDouble) {
                  calcStatus = 'finished';
                }

                var map = item;
                map['status_calculated'] = calcStatus;
                subject = SubjectModel.fromApi(map);
                subjects.add(subject);
              } catch (e) {
                subjects.add(subject);
              }
            }

            SubjectModel? ongoing = subjects
                .where((s) => s.status == 'ongoing')
                .firstOrNull;
            List<SubjectModel> upcoming = subjects
                .where((s) => s.status != 'ongoing' && s.status != 'finished')
                .toList();

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _scheduleFuture = ApiService.getTodaySchedule();
                  _loadUser();
                });
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER SECTION (Original Style) ---
                    _headerSection(context),
                    const SizedBox(height: 30),

                    // --- JADWAL HARI INI ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "JADWAL HARI INI",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 46, 110),
                          ),
                        ),
                        Text(
                          data?['date'] ?? "-",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // LIST OF CARDS
                    if (subjects.isEmpty)
                      SizedBox(
                        height: 300,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_available,
                                size: 60,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Tidak ada jadwal hari ini",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (ongoing == null && upcoming.isEmpty)
                      SizedBox(
                        height: 300,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Tidak ada jadwal hari ini",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      if (ongoing != null) _ongoingCard(context, ongoing),
                      if (ongoing != null) const SizedBox(height: 20),
                      ...upcoming.map(
                        (s) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _comingCard(s),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _headerSection(BuildContext context) {
    return Row(
      children: [
        // Default Profile Icon
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person, size: 30, color: Colors.grey[500]),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Halo,",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                _userName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  size: 26,
                  color: Colors.black87,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/notification').then((_) {
                    // Refresh unread count when returning
                    _loadUnreadCount();
                  });
                },
              ),
            ),
            if (_unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _ongoingCard(BuildContext context, SubjectModel subject) {
    return Container(
      padding: const EdgeInsets.all(20), // Increased padding for proportion
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 0, 46, 110),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(16), // Softer radius
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 46, 110).withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject.title.toUpperCase(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 46, 110),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Sedang berlangsung",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Waktu",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subject.time,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Kelas",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subject.classRoom,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 46, 110),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/bap',
                  arguments: {'session_id': subject.id},
                ).then((_) {
                  setState(() {
                    _scheduleFuture = ApiService.getTodaySchedule();
                  });
                });
              },
              child: const Text(
                "Isi Detail Pertemuan  >",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _comingCard(SubjectModel subject) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA), // Very light grey
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Akan Datang",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Waktu",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subject.time,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Kelas",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subject.classRoom,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 0, 46, 110),
        unselectedItemColor: Colors.grey[400],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/attendance');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}
