import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String type; // 'presensi', 'tugas', 'umum'
  final String title;
  final String description;
  final String time;
  final IconData icon; // Storing generic icon name or mapping usually, but for simplicity we map manually or store code point?
  // Ideally, store 'type' and map type to Icon on UI. But let's follow the request.
  // We'll store a 'type' string and map it to an Icon in the UI or here.
  // Let's store string 'iconName' if necessary, but type is usually enough.
  // The existing hardcode uses IconData directly.
  final Color color;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return _mapData(doc.id, data);
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Laravel structure: details are in 'data' column
    final data = json['data'] ?? {};
    return _mapData(json['id'], data, createdAt: json['created_at']);
  }

  static NotificationModel _mapData(String id, Map<String, dynamic> data, {String? createdAt}) {
    String type = data['type'] ?? 'umum';
    
    // Mapping
    IconData icon = Icons.notifications;
    Color color = Colors.blue;

    if (type == 'presensi' || type == 'attendance') {
      type = 'presensi'; // Normalize
      icon = Icons.check_circle;
      color = Colors.green;
    } else if (type == 'tugas' || type == 'assignment') {
      type = 'tugas'; // Normalize
      icon = Icons.assignment;
      color = Colors.orange;
    }

    // Time formatting if createdAt exists
    // Simple logic: just show created_at string or "Baru saja"
    // Ideally use timeago package, but we keep it simple
    
    return NotificationModel(
      id: id,
      type: type,
      title: data['title'] ?? 'Notifikasi',
      description: data['message'] ?? data['desc'] ?? '',
      time: createdAt ?? data['time'] ?? '', 
      icon: icon, 
      color: color,
    );
  }
}
