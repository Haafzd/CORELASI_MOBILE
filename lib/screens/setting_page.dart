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
        leading:  IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
        title: const Text("Pengaturan")
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Preferensi",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            )
          ),

          // Gunakan Expanded agar isi bisa scroll
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
  Function(String) onLangChanged, // callback
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
