// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_show/data/question_data.dart';
import 'package:quiz_show/widgets/profile_screen/form_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormUserScreen extends StatefulWidget {
  const FormUserScreen({super.key});

  @override
  State<FormUserScreen> createState() => _FormUserScreenState();
}

class _FormUserScreenState extends State<FormUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadDataMahasiswa();
  }

  Future<void> _loadDataMahasiswa() async {
    final prefs = await SharedPreferences.getInstance();
    final nama = prefs.getString('nama');
    final nim = prefs.getString('nim');

    if (nama != null && nim != null) {
      setState(() {
        _namaController.text = nama;
        _nimController.text = nim;
      });
    }
  }

  Future<void> _simpanDataMahasiswa() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nama', _namaController.text);
      await prefs.setString('nim', _nimController.text);

      prefs.remove("answers_${_nimController.text}");
      prefs.remove("questionOrder");

      final existingOrder = prefs.getStringList('questionOrder');
      if (existingOrder == null) {
        List<int> questionOrder = List.generate(
          quizQuestions.length,
          (index) => index,
        )..shuffle();

        await prefs.setStringList(
          'questionOrder',
          questionOrder.map((e) => e.toString()).toList(),
        );
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Data berhasil disimpan!')));

      context.go("/question/0");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Masukkan Data Anda',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Isi data berikut untuk memulai kuis',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Gambar
              Image.asset(
                'assets/image1.png',
                width: double.infinity,
                fit: BoxFit.contain,
              ),

              // Form input
              MahasiswaForm(
                formKey: _formKey,
                namaController: _namaController,
                nimController: _nimController,
              ),

              // Tombol Mulai Kuis
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _simpanDataMahasiswa,
                  icon: const Icon(Icons.arrow_right_alt, color: Colors.white),
                  label: const Text(
                    'Mulai Kuis',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
