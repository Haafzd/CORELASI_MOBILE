import 'package:flutter/material.dart';
import '../screens/setting_page.dart';
import '../screens/attendance.dart';
import '../screens/home_page.dart';

class AppRoutes {
  static const String editAccount = '/edit_account';
  static const String attendance = '/attendance';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    editAccount: (context) => const SettingPage(),
    attendance: (context) => const Attendance(),
    home: (context) => const HomePage(),
  };
}
