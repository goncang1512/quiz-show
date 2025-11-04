import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_show/data/question_data.dart';

class FinishScreen extends StatefulWidget {
  const FinishScreen({super.key});

  @override
  State<FinishScreen> createState() => _FinishScreenState();
}

class _FinishScreenState extends State<FinishScreen> {
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
    final savedName = prefs.getString('name') ?? 'User';
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
      backgroundColor: const Color(0xfff8f9fd),
      body: SafeArea(
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 90,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Kuis Selesai!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Terima kasih telah mengikuti kuis",
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 28,
                              backgroundColor: Color(0xffe8f0fe),
                              child: Icon(
                                Icons.person_outline,
                                color: Colors.blueAccent,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              name ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "NIM: $nim",
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Benar: $correctCount dari $totalQuestions soal",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Skor anda: $score/100",
                              style: TextStyle(
                                color: score == 0
                                    ? Colors.red
                                    : Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      OutlinedButton.icon(
                        onPressed: () {
                          context.go("/");
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          side: const BorderSide(color: Colors.blueAccent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.home_outlined),
                        label: const Text("Kembali ke Beranda"),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
