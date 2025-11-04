import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_show/widgets/question_screen/button_next.dart';
import 'package:quiz_show/widgets/question_screen/card_question.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_show/models/question_model.dart';
import 'package:quiz_show/data/question_data.dart';

class QuestionScreen extends StatefulWidget {
  final String questionId;
  const QuestionScreen({super.key, required this.questionId});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  Question? currentQuestion;
  int totalQuestions = 0;
  int currentIndex = 0;
  String? selectedAnswer;
  Timer? timer;
  int remainingSeconds = 50;
  double progress = 0.0;
  String? nim;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
    _startTimer();
    _loadNim();
  }

  Future<void> _loadNim() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nim = prefs.getString('nim');
    });
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        t.cancel();
        _onTimeUp();
      }
    });
  }

  Future<void> _loadQuestion() async {
    final prefs = await SharedPreferences.getInstance();
    final questionOrderString = prefs.getStringList('questionOrder');

    if (questionOrderString == null) {
      debugPrint("Belum ada data questionOrder di SharedPreferences.");
      return;
    }

    final questionOrder = questionOrderString.map((e) => int.parse(e)).toList();
    currentIndex = int.parse(widget.questionId);
    totalQuestions = questionOrder.length;

    if (currentIndex >= totalQuestions) {
      debugPrint("Index ${widget.questionId} melebihi panjang questionOrder.");
      return;
    }

    final questionIndex = questionOrder[currentIndex];
    final question = quizQuestions[questionIndex];

    setState(() {
      currentQuestion = question;
      progress = (currentIndex + 1) / totalQuestions;
    });
  }

  Future<void> _saveAnswer(String answer) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "answers_$nim";

    final savedData = prefs.getStringList(key) ?? [];

    final filtered = savedData.where((item) {
      print("ITEM : $item");
      final parts = item.split(':');
      return parts.isEmpty || parts[0] != currentQuestion!.id;
    }).toList();

    filtered.add("${currentQuestion!.id}:$answer");

    await prefs.setStringList(key, filtered);
  }

  void _nextQuestion() {
    timer?.cancel();
    if (currentIndex + 1 < totalQuestions) {
      context.go("/question/${currentIndex + 1}");
    } else {
      context.go("/finish");
    }
  }

  void _onTimeUp() {
    _saveAnswer(selectedAnswer ?? "");
    _nextQuestion();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fd),
      body: currentQuestion == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Quiz Show",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "$remainingSeconds dtk",
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Pertanyaan ${currentIndex + 1} dari $totalQuestions",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 20),

                    // CARD PERTANYAAN
                    CardQuestion(
                      selectedAnswer: selectedAnswer,
                      currentQuestion: currentQuestion,
                      currentIndex: currentIndex,
                      saveAnswer: _saveAnswer,
                    ),

                    const Spacer(),
                    ButtonNext(
                      nextQuestion: _nextQuestion,
                      selectedAnswer: selectedAnswer,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
