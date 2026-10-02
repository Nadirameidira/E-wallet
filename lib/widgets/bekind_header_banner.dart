import 'package:flutter/material.dart';
import '../utils/colors.dart';

class BeKindHeaderBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const BeKindHeaderBanner({
    super.key,
    this.title = 'Bagikan Kebaikan',
    this.subtitle =
        'Buat BE KIND, bagikan kodenya,\ndan biarkan temanmu klaim saldonya!',
    this.icon = Icons.favorite,
  });

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
          Icon(icon, color: AppColors.orange, size: 48),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.orange,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ],
      ),
    );
  }
}