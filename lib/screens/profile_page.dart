import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await ApiService.getStoredUser();
    setState(() {
      _user = user;
    });
  }

  Future<void> _logout() async {
    await ApiService.logout();
    if (mounted) {
      // Navigate to Login and remove all previous routes
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Brand Colors
<<<<<<< HEAD
=======
    final primaryBlue = const Color.fromARGB(255, 0, 71, 124);
>>>>>>> 2a093b206b760307949ecae6cdb13d6f4a770c20
    final textDarkBlue = const Color.fromARGB(255, 0, 46, 110);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: Text(
            "Profil Saya", 
            style: TextStyle(
              color: textDarkBlue, 
              fontWeight: FontWeight.bold, 
              fontSize: 24
            )
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: _bottomNavBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Profile Card (Consistent with BAP Header)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 46, 110), // Primary Blue (Matches Home)
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 0, 46, 110).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4)
                  )
                ]
              ),
              child: Column(
                children: [
                   // Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
                      boxShadow: [
                         BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
                      ]
                    ),
                    child: Icon(Icons.person, size: 60, color: const Color.fromARGB(255, 0, 46, 110)),
                  ),
                  const SizedBox(height: 20),
                  
                  // Text Info
                  Text(
                     _user?['name'] ?? "Guru",
                    style: const TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                     _user?['email'] ?? "-",
                    style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Divider(color: Colors.white.withOpacity(0.2)),
                  const SizedBox(height: 10),
                  
                  // Role / NIP
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.badge_outlined, size: 18, color: Colors.white.withOpacity(0.7)),
                      const SizedBox(width: 8),
                      Text(
                         _user?['nip'] != null ? "NIP: ${_user!['nip']}" : "Pengajar",
                         style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500)
                      ),
                    ],
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Logout Button (Consistent Style)
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Matched Attendance Buttons
                    side: BorderSide(color: Colors.red.shade100, width: 1.5)
                  ),
                ),
                onPressed: _logout,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Icon(Icons.logout_rounded),
                     SizedBox(width: 10),
                    Text("Keluar Aplikasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            Text("Versi Aplikasi 1.0.0", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
         border: Border(top: BorderSide(color: Colors.grey[200]!))
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.grey[400],
        unselectedItemColor: Colors.grey[400],
        currentIndex: 2, // Check 'Person'
        onTap: (index) {
          if (index == 0) {
            // Go back to Home (Root)
            Navigator.pop(context);
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/attendance');
          }
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 28), label: ''),
          const BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner_rounded, size: 28), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded, size: 28, color: const Color.fromARGB(255, 0, 46, 110)), 
            label: ''
          ),
        ],
      ),
    );
  }
}
