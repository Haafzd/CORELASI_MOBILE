import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int selectedTab = 0; // 0 = Semua, 1 = Tugas, 2 = Presensi
  bool allRead = false;

  List<Map<String, dynamic>> notifications = [
    {
      "type": "presensi",
      "title": "Presensi Berhasil",
      "desc": "Kamu sudah presensi untuk mata pelajaran Bahasa Indonesia",
      "time": "5 menit lalu",
      "icon": Icons.check_circle,
      "color": Colors.green
    },
    {
      "type": "tugas",
      "title": "Tugas Baru : Matematika",
      "desc": "Bu Nabila memberikan tugas baru dengan deadline 10 Maret 2025",
      "time": "1 jam lalu",
      "icon": Icons.assignment,
      "color": Colors.red
    },
    {
      "type": "umum",
      "title": "Pengumuman Upacara Bendera",
      "desc": "Besok akan ada upacara. Harap hadir tepat waktu pukul 07.00",
      "time": "2 jam lalu",
      "icon": Icons.notifications,
      "color": Colors.purple
    },
    {
      "type": "presensi",
      "title": "Presensi Berhasil",
      "desc": "Kamu sudah presensi untuk mata pelajaran Matematika",
      "time": "2 hari lalu",
      "icon": Icons.check_circle,
      "color": Colors.green
    },
    {
      "type": "tugas",
      "title": "Reminder : Tugas Bahasa Indonesia",
      "desc": "Deadline : Tugas esai dalam 2 hari lagi",
      "time": "3 hari lalu",
      "icon": Icons.assignment,
      "color": Colors.red
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back),
                  const SizedBox(width: 10),
                  const Text(
                    "Notifikasi",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),

                  // Tombol "Tandai Semua"
                  InkWell(
                    onTap: () {
                      setState(() {
                        allRead = true;
                      });
                    },
                    child: const Text(
                      "Tandai Semua",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "3 Notifikasi belum dibaca",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 10),

            // Tab menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  buildTabButton("Semua", 0),
                  buildTabButton("Tugas", 1),
                  buildTabButton("Presensi", 2),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // List notifikasi
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: buildNotificationList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTabButton(String label, int index) {
    bool active = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: active ? Colors.blue.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active ?  Color.fromARGB(255, 0, 46, 110) : Colors.grey.shade300,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active ? Color.fromARGB(255, 0, 46, 110) : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildNotificationList() {
    List<Map<String, dynamic>> filtered = notifications;

    if (selectedTab == 1) {
      filtered = notifications.where((n) => n["type"] == "tugas").toList();
    } else if (selectedTab == 2) {
      filtered = notifications.where((n) => n["type"] == "presensi").toList();
    }

    return filtered.map((item) {
      return buildNotificationCard(item);
    }).toList();
  }

  Widget buildNotificationCard(Map<String, dynamic> n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(n["icon"], color: n["color"]),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      n["title"],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    if (!allRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  n["desc"],
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Text(
                  n["time"],
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
