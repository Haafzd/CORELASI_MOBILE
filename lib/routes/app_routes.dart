import 'package:flutter/material.dart';
import '../screens/setting_page.dart';

class AppRoutes {
  static const String editAccount = '/edit_account';

  static Map<String, WidgetBuilder> routes = {
    editAccount: (context) => const SettingPage(),
  };
}