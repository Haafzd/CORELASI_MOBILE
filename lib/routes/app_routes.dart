import 'package:flutter/material.dart';
import '../screens/attendance.dart';
import '../screens/home_page.dart';
import '../screens/notification_screen.dart';
import '../screens/profile_page.dart';

class AppRoutes {
  static const String editAccount = '/edit_account';
  static const String attendance = '/attendance';
  static const String home = '/home';
  static const String notification = '/notification';
  static const String profilePage = '/profile_page';

  static Map<String, WidgetBuilder> routes = {
    profilePage: (context) => const ProfilePage(),
    attendance: (context) => const Attendance(),
    home: (context) => const HomePage(),
    notification: (context) => const NotificationScreen(),
  };
}
