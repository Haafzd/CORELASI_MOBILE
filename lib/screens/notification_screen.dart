import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.3,
        title: const Text(
          "Notifikasi",
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                "Tandai Semua",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          // ---------- Tab Bar ----------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              controller: tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              indicator: BoxDecoration(
                color: Color.fromARGB(255, 0, 46, 110),
                borderRadius: BorderRadius.circular(12),
              ),
              tabs: const [
                Tab(text: "Semua"),
                Tab(text: "Tugas"),
                Tab(text: "Presensi"),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ---------- Tab View ----------
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _buildAllNotifications(),
                _buildTaskNotifications(),
                _buildPresenceNotifications(),
              ],
            ),
          )
        ],
      ),
    );
  }

  //  TAMPILAN TAB: SEMUA
  Widget _buildAllNotifications() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        NotifCard(
          title: "Presensi Berhasil",
          subtitle:
              "Kamu berhasil presensi untuk mata pelajaran Bahasa Indonesia",
          time: "5 menit lalu",
          icon: Icons.check_circle,
          iconColor: Colors.green,
        ),
        NotifCard(
          title: "Tugas Baru - Matematika",
          subtitle: "Buatlah rumus / matematika dengan deadline 13 Maret 2025",
          time: "1 jam lalu",
          icon: Icons.assignment,
          iconColor: Colors.red,
        ),
        NotifCard(
          title: "Pengumuman Upacara Bendera",
          subtitle: "Besok semua murid diharapkan memakai seragam lengkap.",
          time: "3 jam lalu",
          icon: Icons.campaign,
          iconColor: Colors.purple,
        ),
        NotifCard(
          title: "Presensi Berhasil",
          subtitle: "Kamu berhasil presensi untuk mata pelajaran Matematika",
          time: "2 hari lalu",
          icon: Icons.check_circle,
          iconColor: Colors.green,
        ),
        NotifCard(
          title: "Reminder - Tugas Bahasa Indonesia",
          subtitle: "Deadline tugas akan berakhir 2 hari lagi",
          time: "3 hari lalu",
          icon: Icons.notifications,
          iconColor: Colors.red,
        ),
      ],
    );
  }

  //  TAMPILAN TAB: TUGAS
  Widget _buildTaskNotifications() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        NotifCard(
          title: "Tugas Baru - Matematika",
          subtitle: "Buatlah rumus / matematika dengan deadline 13 Maret 2025",
          time: "1 jam lalu",
          icon: Icons.assignment,
          iconColor: Colors.red,
        ),
        NotifCard(
          title: "Reminder - Tugas Bahasa Indonesia",
          subtitle: "Deadline tugas akan berakhir 2 hari lagi",
          time: "2 hari lalu",
          icon: Icons.notifications,
          iconColor: Colors.red,
        ),
      ],
    );
  }

  //  TAMPILAN TAB: PRESENSI
  Widget _buildPresenceNotifications() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        NotifCard(
          title: "Presensi Berhasil",
          subtitle:
              "Kamu berhasil presensi untuk mata pelajaran Bahasa Indonesia",
          time: "5 menit lalu",
          icon: Icons.check_circle,
          iconColor: Colors.green,
        ),
        NotifCard(
          title: "Presensi Berhasil",
          subtitle: "Kamu berhasil presensi untuk mata pelajaran Matematika",
          time: "1 jam lalu",
          icon: Icons.check_circle,
          iconColor: Colors.green,
        ),
      ],
    );
  }
}

// KOMPONEN KARTU
class NotifCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;

  const NotifCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
