import 'package:corelasi_simple/screens/bap_page.dart';
import 'package:corelasi_simple/screens/login_page.dart';
import 'package:flutter/material.dart';
import '../screens/attendance.dart';
import '../screens/home_page.dart';
import '../screens/notification_screen.dart';
import '../screens/profile_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String attendance = '/attendance';
  static const String home = '/home';
  static const String bap = '/bap';
  static const String notification = '/notification';
  static const String profilePage = '/profile_page';

  static const String profile = '/profile';

  static Map<String, WidgetBuilder> routes = {
<<<<<<< HEAD
    login: (context) => const LoginPage(),
=======
    profilePage: (context) => const ProfilePage(),
>>>>>>> 2a093b206b760307949ecae6cdb13d6f4a770c20
    attendance: (context) => const Attendance(),
    home: (context) => const HomePage(),
    bap: (context) => const BapPage(),
    notification: (context) => const NotificationScreen(),
    profile: (context) => const ProfilePage(),
  };
}
