import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/notification_model.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int selectedTab = 0; // 0 = Semua, 1 = Tugas, 2 = Presensi
  bool _isLoading = true;
  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    // Auto mark all read when opening screen
    _markAllRead();
  }

  Future<void> _loadNotifications() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    String typeIdx = 'all';
    if (selectedTab == 1) typeIdx = 'tugas';
    if (selectedTab == 2) typeIdx = 'presensi';

    try {
      final res = await ApiService.getNotifications(type: typeIdx);
      final rawData = res['notifications']['data'] as List; // Pagination wrapper
      
      final List<NotificationModel> loaded = rawData.map((json) => NotificationModel.fromJson(json)).toList();
      
      if (!mounted) return;
      setState(() {
        _notifications = loaded;
        _unreadCount = res['unread_count'] ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      print("Err load notif: $e");
    }
  }

  Future<void> _markAllRead() async {
    await ApiService.markAllRead();
    _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // Light grey background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "Notifikasi",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 46, 110),
          ),
        ),
      ),

      body: Column(
        children: [
           Container(
             color: Colors.white,
             padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
             child: Column(
               children: [
                 Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$_unreadCount Notifikasi belum dibaca",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Tabs
                  Row(
                    children: [
                      buildTab("Semuanya", 0),
                      buildTab("Tugas", 1),
                      buildTab("Presensi", 2),
                    ],
                  ),
               ],
             ),
           ),
           
           Expanded(
             child: _isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : _notifications.isEmpty
                  ? Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey[300]),
                         const SizedBox(height: 10),
                         Text("Tidak ada notifikasi", style: TextStyle(color: Colors.grey[500]))
                      ]
                    ))
                  : RefreshIndicator(
                      onRefresh: _loadNotifications,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) => buildNotificationCard(_notifications[index]),
                      ),
                    )
           )
        ],
      ),
    );
  }


  // widget tab
  Widget buildTab(String text, int index) {
    bool active = selectedTab == index;
    final primaryBlue = const Color.fromARGB(255, 0, 71, 124);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
          _loadNotifications();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: active ? primaryBlue : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active ? primaryBlue : Colors.grey.shade300,
            ),
             boxShadow: active ? [BoxShadow(color: primaryBlue.withOpacity(0.3), blurRadius: 4, offset: const Offset(0,2))] : []
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: active ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  // widget notification
  Widget buildNotificationCard(NotificationModel n) {
    // Basic date parsing if possible (Laravel timestamps are ISO like 2024-12-28T04:20:00.000000Z)
    String timeStr = n.time;
    try {
       final dt = DateTime.parse(n.time);
       timeStr = DateFormat('dd MMM HH:mm').format(dt.toLocal());
    } catch (_) {}

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
           BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
             padding: const EdgeInsets.all(10),
             decoration: BoxDecoration(
                color: n.color.withOpacity(0.1),
                shape: BoxShape.circle
             ),
             child: Icon(n.icon, color: n.color, size: 24),
          ),
          const SizedBox(width: 15),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        n.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 46, 110)
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      timeStr,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  n.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
