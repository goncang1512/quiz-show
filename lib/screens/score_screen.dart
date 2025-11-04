import 'package:flutter/material.dart';
import 'package:quiz_show/data/question_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class LastScoreScreen extends StatefulWidget {
  const LastScoreScreen({super.key});

  @override
  State<LastScoreScreen> createState() => _LastScoreScreenState();
}

class _LastScoreScreenState extends State<LastScoreScreen> {
  int score = 0;
  int correctCount = 0;
  int totalQuestions = 0;
  String? nim;
  String? name;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScore();
  }

  Future<void> _loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNim = prefs.getString('nim') ?? 'Tidak diketahui';
    final savedName = prefs.getString('nama') ?? 'User';
    final key = "answers_$savedNim";
    final savedData = prefs.getStringList(key);

    int tempCorrect = 0;
    int total = quizQuestions.length;

    if (savedData != null) {
      for (var item in savedData) {
        final parts = item.split(':');
        if (parts.length == 2) {
          final questionId = parts[0];
          final userAnswer = parts[1];
          final question = quizQuestions.firstWhere(
            (q) => q.id == questionId,
            orElse: () => throw Exception("Question not found"),
          );
          if (question.answer == userAnswer) {
            tempCorrect += 1;
          }
        }
      }
    }

    final tempScore = total > 0 ? ((tempCorrect / total) * 100).round() : 0;

    setState(() {
      nim = savedNim;
      name = savedName;
      correctCount = tempCorrect;
      totalQuestions = total;
      score = tempScore;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      appBar: AppBar(
        title: const Text('Skor Terakhir'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon centang hijau
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                "Skor Terakhir Anda",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Nama dan NIM
              if (name != null && nim != null)
                Column(
                  children: [
                    Text(
                      name!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nim!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 24),

              // Kartu skor
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Nilai Akhir",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$score",
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4285F4),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.go('/');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF4285F4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Kembali ke Beranda",
                        style: TextStyle(
                          color: Color(0xFF4285F4),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
