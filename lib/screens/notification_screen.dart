import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int selectedTab = 0; // 0 = Semua, 1 = Tugas, 2 = Presensi
  bool allRead = false;

  List<Map<String, dynamic>> notifications = [
    {
      "type": "presensi",
      "title": "Presensi Berhasil",
      "desc":
          "Kamu sudah presensi untuk mata pelajaran Bahasa Indonesia",
      "time": "5 menit lalu",
      "icon": Icons.check_circle,
      "color": Colors.green
    },
    {
      "type": "tugas",
      "title": "Tugas Baru : Matematika",
      "desc":
          "Bu Nabila memberikan tugas baru dengan deadline 10 Maret 2025",
      "time": "1 jam lalu",
      "icon": Icons.assignment,
      "color": Colors.red
    },
    {
      "type": "umum",
      "title": "Pengumuman Upacara",
      "desc":
          "Besok akan ada upacara. Harap hadir tepat waktu pukul 07.00",
      "time": "2 jam lalu",
      "icon": Icons.notifications,
      "color": Colors.purple
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      //  AppBar buat icon back
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context), // <- Back jalan 100%
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: false,
        title: const Text(
          "Notifikasi",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                allRead = true; // tandai semua
              });
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Text(
                "Tandai Semua",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "3 Notifikasi belum dibaca",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ),

          const SizedBox(height: 14),

          //  Tab Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                buildTab("Semuanya", 0),
                buildTab("Tugas", 1),
                buildTab("Presensi", 2),
              ],
            ),
          ),

          const SizedBox(height: 10),

          //  List Notifikasi
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: buildNotificationList(),
            ),
          )
        ],
      ),
    );
  }


  // widget tab
  Widget buildTab(String text, int index) {
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
              color: active ? Colors.blue : Colors.grey.shade300,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: active ? Colors.blue : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // filter list
  List<Widget> buildNotificationList() {
    List<Map<String, dynamic>> filtered = notifications;

    if (selectedTab == 1) {
      filtered =
          notifications.where((x) => x["type"] == "tugas").toList();
    } else if (selectedTab == 2) {
      filtered =
          notifications.where((x) => x["type"] == "presensi").toList();
    }

    return filtered.map((n) => buildNotificationCard(n)).toList();
  }

 
  // widget notification

  Widget buildNotificationCard(Map<String, dynamic> n) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(n["icon"], color: n["color"]),
          const SizedBox(width: 12),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      n["title"],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const Spacer(),
                    
                    if (!allRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  n["desc"],
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  n["time"],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
