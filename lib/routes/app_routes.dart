import 'package:flutter/material.dart';
import '../screens/setting_page.dart';
import '../screens/attendance.dart';

class AppRoutes {
  static const String editAccount = '/edit_account';
  static const String attendance = '/attendance';

  static Map<String, WidgetBuilder> routes = {
    editAccount: (context) => const SettingPage(),
    attendance: (context) => const Attendance()
  };
}
