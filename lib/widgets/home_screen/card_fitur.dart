import 'package:flutter/material.dart';

class CardFitur extends StatelessWidget {
  const CardFitur({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fitur Utama:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color(0xFFDBEAFE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF2563EB),
                size: 20,
              ),
            ),

            SizedBox(width: 8),
            Text('Kuis pilihan ganda'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color(0xFFFEF9C3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.emoji_events,
                color: Color(0xFFD99804),
                size: 20,
              ),
            ),
            SizedBox(width: 8),
            Text('Score terakhir'),
          ],
        ),
      ],
    );
  }
}
