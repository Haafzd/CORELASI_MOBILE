import 'package:flutter/material.dart';
import '../color.dart';

class AttendanceRecapScreen extends StatelessWidget {
  AttendanceRecapScreen({super.key});

  // dummy data siswa
  final List<Map<String, String>> students = [
  {'name': 'Hafidz Musyafa Azmi', 'status': 'Tidak hadir'}, 
  {'name': 'Gilang Tirta Kusuma', 'status': 'Hadir'},       
  {'name': 'Fadli Muhammad Dzaky', 'status': 'Hadir'},      
  {'name': 'Haafidz Alhabib Azwir', 'status': 'Hadir'},     
  {'name': 'Muhammad Thoriq Marcello', 'status': 'Hadir'},  
  {'name': 'Muhammad Reza Ferdinal', 'status': 'Hadir'},    
  {'name': 'Pieter Immanuel Sinaga', 'status': 'Hadir'},    
  {'name': 'Muhammad Ilham Ridzuan', 'status': 'Hadir'},    
  {'name': 'Avriela Nada Amara P', 'status': 'Hadir'},      
  {'name': 'Nadya Sekar Rahmawati', 'status': 'Hadir'},     
  {'name': 'Kyreina Oktaria Putri', 'status': 'Hadir'},     
  {'name': 'Alfian Rizky Sabian', 'status': 'Hadir'},       
  {'name': 'Raihan Ahmad Fadhilah', 'status': 'Hadir'},     
  {'name': 'Salsabila Nur Azzahra', 'status': 'Hadir'},     
  {'name': 'Iqbal Faqih Ramadhan', 'status': 'Hadir'},      
  {'name': 'Farrel Dwi Pratama', 'status': 'Hadir'},        
  {'name': 'Dinda Maharani Putri', 'status': 'Hadir'},      
  {'name': 'Zahra Khairunnisa', 'status': 'Hadir'},        
  {'name': 'Rafli Maulana Akbar', 'status': 'Hadir'},       
  {'name': 'Bella Citra Ayuningtyas', 'status': 'Hadir'},   
  {'name': 'Rizky Ananda Putra', 'status': 'Hadir'},        
  {'name': 'Azka Rafi Alamsyah', 'status': 'Hadir'},        
  {'name': 'Putri Aulia Rahma', 'status': 'Hadir'},         
  {'name': 'Noval Dwi Kusuma', 'status': 'Hadir'},          
  {'name': 'Silvia Agustin', 'status': 'Hadir'},            
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Rekap Absensi',
          style: TextStyle(
            color: AppColors.textDarkBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // tanggal
            const Text(
              'Selasa , 04 Maret 2025',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // judul + 3 kotak rekap
            Text(
              'Rekap Presensi Kehadiran Siswa',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDarkBlue,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                _SummaryBox(label: 'Total', value: '25'),
                SizedBox(width: 8),
                _SummaryBox(label: 'Hadir', value: '24'),
                SizedBox(width: 8),
                _SummaryBox(label: 'tidak hadir', value: '1'),
              ],
            ),
            const SizedBox(height: 16),

            // BOX: Daftar siswa + list
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header "Daftar Siswa" DI DALAM box
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        'Daftar Siswa',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDarkBlue,
                        ),
                      ),
                    ),
                    Divider(height: 1, color: Colors.grey.shade300),

                    // list siswa
                    Expanded(
                      child: ListView.separated(
                        itemCount: students.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: Colors.grey.shade200,
                        ),
                        itemBuilder: (context, index) {
                          final student = students[index];
                          final isPresent = student['status']!
                                  .toLowerCase()
                                  .contains('hadir') &&
                              !student['status']!
                                  .toLowerCase()
                                  .contains('tidak');

                          return Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    student['name']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _StatusChip(
                                  isPresent: isPresent,
                                  primaryBlue: AppColors.primaryBlue,
                                  textDarkBlue: AppColors.textDarkBlue,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kotak kecil: Total / Hadir / tidak hadir
class _SummaryBox extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip Hadir / Tidak hadir persegi tumpul kecil
class _StatusChip extends StatelessWidget {
  final bool isPresent;
  final Color primaryBlue;
  final Color textDarkBlue;

  const _StatusChip({
    required this.isPresent,
    required this.primaryBlue,
    required this.textDarkBlue,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isPresent ? primaryBlue : Colors.white;
    final borderColor = isPresent ? primaryBlue : textDarkBlue;
    final textColor = isPresent ? Colors.white : textDarkBlue;
    final label = isPresent ? 'Hadir' : 'Tidak hadir';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4), 
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
