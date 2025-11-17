import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<StatefulWidget> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final List<Map<String, dynamic>> students = [
    {'name': 'Gilang Tirta Kusuma', 'status': 'Hadir'},
    {'name': 'Nashbilla nurfazza', 'status': 'Hadir'},
    {'name': 'Khansa aulia fauzah', 'status': 'tidak hadir'},
    {'name': 'Hafidz Musyafa Azmi', 'status': 'Tidak Hadir'},
    {'name': 'Fadhli Muhammad Dzaki', 'status': 'Hadir'},
    {'name': 'Haafizd alhabib azwir', 'status': 'Tidak Hadir'},
  ];

  final Color primaryBlue = const Color.fromARGB(255, 0, 71, 124);
  final Color textDarkBlue = const Color.fromARGB(255, 0, 46, 110);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),
              const SizedBox(height: 20),
              buildClassInfoCard(),
              const SizedBox(height: 15),
              materialCardSect(),
              const SizedBox(height: 20),
              Text(
                "Rekap Presensi Kehadiran Siswa",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textDarkBlue,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: sumBox("25", "Total")),
                  const SizedBox(width: 10),
                  Expanded(child: sumBox("24", "Hadir")),
                  const SizedBox(width: 10),
                  Expanded(child: sumBox("1", "Tidak hadir")),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                  label: const Text(
                    "Scan QR Siswa",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              stdnListSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    final String liveDate =
        DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());
    return Row(
      children: [
        const BackButton(),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kehadiran",
              style: TextStyle(
                  color: textDarkBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "${liveDate}",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ],
        )
      ],
    );
  }

  Widget buildClassInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Sedang berlangsung",
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Bahasa Indonesia",
            style: TextStyle(
                color: textDarkBlue, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text("IPS 1", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 15),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Waktu", style: TextStyle(color: Colors.grey)),
                  Text("08:30 - 09:30",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Kelas", style: TextStyle(color: Colors.grey)),
                  Text("IPS 1", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget materialCardSect() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Materi Hari Ini",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: textDarkBlue, fontSize: 16),
          ),
          const SizedBox(height: 5),
          const Text(
            "Teks Eksposisi dan Struktur Kalimat",
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }

  //rekap
  Widget sumBox(String count, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

//daftarn sswa
  Widget stdnListSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Daftar Siswa",
                  style: TextStyle(
                      color: textDarkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text("Lihat Detail",
                          style: TextStyle(
                              color: textDarkBlue,
                              fontWeight: FontWeight.bold)),
                      const Icon(Icons.chevron_right, size: 18)
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: students.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final student = students[index];
              final isPresent = student['status'] == 'Hadir';

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      student['name'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPresent ? primaryBlue : Colors.white,
                        border: Border.all(
                            color: isPresent ? primaryBlue : textDarkBlue),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        student['status'],
                        style: TextStyle(
                          color: isPresent ? Colors.white : textDarkBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
