import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/colors.dart';

class BeKindCodeCard extends StatelessWidget {
  final String code;

  const BeKindCodeCard({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 224, 130),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.card_giftcard, color: AppColors.orange, size: 40),
          const SizedBox(height: 12),
          const Text(
            'Kode BE KIND Kamu',
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 8),
          SelectableText(
            code,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.orange,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kode disalin! 🐾')),
              );
            },
            icon: const Icon(Icons.copy, color: AppColors.orange, size: 18),
            label: const Text(
              'Salin Kode',
              style: TextStyle(color: AppColors.orange),
            ),
          ),
        ],
      ),
    );
  }
}