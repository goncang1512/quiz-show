import 'package:flutter/material.dart';

class ButtonNext extends StatelessWidget {
  final void Function() nextQuestion;
  final String? selectedAnswer;
  const ButtonNext({
    super.key,
    required this.nextQuestion,
    required this.selectedAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: nextQuestion,
        icon: const Icon(Icons.arrow_forward_rounded),
        label: Text(
          "Selanjutnya",
          style: TextStyle(
            color: selectedAnswer == null
                ? const Color.fromARGB(255, 78, 78, 78)
                : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
