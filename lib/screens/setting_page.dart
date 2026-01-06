import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isNotif = false;
  String selectedLang = 'Indonesia';
  final List<String> languages = ['Indonesia', 'English'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("Pengaturan")),
      body: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileCard(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Preferensi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            )
          ),
          
          Expanded(
            child: ListView(
              children: [
                prefensi(
                  isNotif,
                  (value) => setState(() => isNotif = value),
                  selectedLang,
                  languages,
                  (value) => setState(() => selectedLang = value),
                ),
                const Divider(),
                Logout(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget prefensi(
  bool isNotif,
  Function(bool) onNotifChanged,
  String selectedLang,
  List<String> languages,
  Function(String) onLangChanged, 
) {
  return Column(
    children: <Widget>[
      ListTile(
        leading: const Icon(Icons.notifications_active),
        title: const Text("Notifikasi"),
        trailing: CupertinoSwitch(
          value: isNotif,
          onChanged: onNotifChanged,
        ),
      ),
      ListTile(
        leading: const Icon(Icons.language),
        title: const Text("Bahasa"),
        trailing: DropdownButton<String>(
          value: selectedLang,
          onChanged: (value) {
            if (value != null) {
              onLangChanged(value);
            }
          },
          items: languages.map((lang) {
            return DropdownMenuItem(
              value: lang,
              child: Text(lang),
            );
          }).toList(),
        ),
      ),
    ],
  );
}

Widget Logout() {
  return ListTile(
    leading: const Icon(Icons.logout, color: Colors.red),
    title: const Text("Log Out"),
    onTap: () {
      debugPrint("User logged out");
    },
  );
}

Widget ProfileCard() {
  return Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.symmetric(vertical: 20),
    width:double.infinity,
    decoration: BoxDecoration(
      color: const Color(0xFF1E5A85), 
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundColor: Colors.grey, 
        ),
        const SizedBox(height: 10),
        const Text(
          "calon pengguna",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
