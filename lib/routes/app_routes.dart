import 'package:corelasi_simple/screens/bap_page.dart';
import 'package:flutter/material.dart';
import '../screens/setting_page.dart';
import '../screens/attendance.dart';
import '../screens/home_page.dart';
import '../screens/notification_screen.dart';

class AppRoutes {
  static const String editAccount = '/edit_account';
  static const String attendance = '/attendance';
  static const String home = '/home';
  static const String bap = '/bap';
  static const String notification = '/notification';

  static Map<String, WidgetBuilder> routes = {
    editAccount: (context) => const SettingPage(),
    attendance: (context) => const Attendance(),
    home: (context) => const HomePage(),
    bap: (context) => const BapPage(),
    notification: (context) => const NotificationScreen(),
  };
}
