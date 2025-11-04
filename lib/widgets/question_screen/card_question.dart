import 'package:flutter/material.dart';
import 'package:quiz_show/models/question_model.dart';
import 'dart:math';

class CardQuestion extends StatefulWidget {
  final int currentIndex;
  final Question? currentQuestion;
  final String? selectedAnswer;
  final Future<void> Function(String answer) saveAnswer;

  const CardQuestion({
    super.key,
    required this.currentIndex,
    required this.currentQuestion,
    this.selectedAnswer,
    required this.saveAnswer,
  });

  @override
  State<CardQuestion> createState() => _CardQuestionState();
}

class _CardQuestionState extends State<CardQuestion> {
  String? _selectedAnswer;
  late List<String> _shuffledOptions;

  @override
  void initState() {
    super.initState();
    _selectedAnswer = widget.selectedAnswer;
    _shuffleOptions();
  }

  @override
  void didUpdateWidget(covariant CardQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentQuestion?.id != widget.currentQuestion?.id) {
      _selectedAnswer = widget.selectedAnswer;
      _shuffleOptions();
    }
  }

  void _shuffleOptions() {
    final originalOptions = List<String>.from(widget.currentQuestion!.options);
    originalOptions.shuffle(Random());
    _shuffledOptions = originalOptions;
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = widget.currentQuestion;
    if (currentQ == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pertanyaan ${widget.currentIndex + 1}",
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currentQ.question,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          ...List.generate(_shuffledOptions.length, (index) {
            final option = _shuffledOptions[index];
            final label = String.fromCharCode(65 + index);
            final isSelected = _selectedAnswer == option;

            return GestureDetector(
              onTap: () {
                setState(() => _selectedAnswer = option);
                widget.saveAnswer(option);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey.shade300,
                    width: 2,
                  ),
                  color: isSelected
                      ? Colors.blue.withValues(alpha: 0.1)
                      : Colors.white,
                ),
                child: Row(
                  children: [
                    Text(
                      "$label. ",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Expanded(child: Text(option)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
