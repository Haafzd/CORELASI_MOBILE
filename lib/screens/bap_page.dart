import 'package:flutter/material.dart';

class BapPage extends StatefulWidget {
  const BapPage({super.key});

  @override
  State<BapPage> createState() => _BapPageState();
}

class _BapPageState extends State<BapPage> {
  final _formKey = GlobalKey<FormState>();

  final _materiController = TextEditingController();
  final _indikatorController = TextEditingController();
  final _tempatController = TextEditingController();

  @override
  void dispose() {
    _materiController.dispose();
    _indikatorController.dispose();
    _tempatController.dispose();
    super.dispose();
  }

  void _simpanForm() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('BAP berhasil disimpan!')),
      );

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua field')),
      );
    }
  }

  void _batal() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: Navigator.of(context).pop,
        ),
        title: Text(
          "Detail Pertemuan",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromRGBO(0, 51, 102, 1)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1.0,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsetsGeometry.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BAHASA INDONESIA',
                style: TextStyle(
                    color: Color.fromRGBO(0, 51, 102, 1),
                    fontSize: 24,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Kelas IPS 1',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 50,
              ),
              const Text(
                'Deskripsi Pertemuan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Field Materi
              _buildTextFormField(
                controller: _materiController,
                labelText: 'Materi',
                hintText: 'Masukkan materi yang diajarkan...',
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              // Field Indikator Pencapaian
              _buildTextFormField(
                controller: _indikatorController,
                labelText: 'Indikator Pencapaian',
                hintText: 'Masukkan indikator pencapaian...',
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              // Field Tempat
              _buildTextFormField(
                controller: _tempatController,
                labelText: 'Tempat',
                hintText: 'Misal: Ruang 301, Google Meet, dll.',
                maxLines: 1,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _batal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0055A4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // save button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _simpanForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0055A4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}

Widget _buildTextFormField({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  int maxLines = 1,
}) {
  return TextFormField(
    controller: controller,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      alignLabelWithHint: true,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
    // Validator
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return '$labelText tidak boleh kosong';
      }
      return null;
    },
  );
}
