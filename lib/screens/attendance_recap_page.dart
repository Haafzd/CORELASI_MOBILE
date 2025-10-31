import 'package:flutter/material.dart';

class DataPresensiPage extends StatelessWidget {
  const DataPresensiPage({super.key});

  // Contoh data
  List<Map<String, String>> get _data => const [
        {"nama": "Ababil", "status": "Hadir"},
        {"nama": "Gilang", "status": "Sakit"},
        {"nama": "Patli", "status": "-"},
        {"nama": "Asuy", "status": "Izin"},
      ];

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF3F4F6); // #f3f4f6

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Biar nyaman di device lebar
            final maxW = constraints.maxWidth > 640 ? 560.0 : double.infinity;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxW),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Judul
                      Text(
                        "DATA PRESENSI",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: Colors.black.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card putih
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A000000), // ~10% hitam
                              blurRadius: 18,
                              spreadRadius: 1,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: _buildTable(context),
                      ),

                      const SizedBox(height: 16),

                      // Tombol Kembali
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD1D5DB), // abu terang
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          child: const Text("Kembali"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    final headerStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Colors.black.withOpacity(0.85),
    );

    final cellStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black.withOpacity(0.85),
    );

    // Gunakan Table agar mudah buat garis vertikal & alignment
    return Table(
      // Garis pembatas vertikal di antara dua kolom
      border: TableBorder(
        verticalInside: BorderSide(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FlexColumnWidth(2), // Nama Siswa (lebih lebar)
        1: FlexColumnWidth(1), // Status
      },
      children: [
        // Header
        TableRow(
          decoration: BoxDecoration(
            // Garis horizontal tipis di bawah header
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          children: [
            _cell(
              child: Text("Nama Siswa", style: headerStyle),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              align: Alignment.centerLeft,
            ),
            _cell(
              child: Text("Status", style: headerStyle),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              align: Alignment.centerLeft,
            ),
          ],
        ),

        // Data rows
        ..._data.map((row) {
          return TableRow(
            children: [
              _cell(
                child: Text(row["nama"]!, style: cellStyle),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                // Teks rapi & selaras tengah vertikal sudah dari Table
                // Untuk horizontal rapi kiri
                align: Alignment.centerLeft,
              ),
              _cell(
                child: Text(row["status"]!, style: cellStyle),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                align: Alignment.centerLeft,
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _cell({
    required Widget child,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    AlignmentGeometry align = Alignment.centerLeft,
  }) {
    return Container(
      alignment: align,
      padding: padding,
      child: child,
    );
  }
}
