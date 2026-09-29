import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/bekind_header_banner.dart';
import '../widgets/bekind_menu_tile.dart';
import 'bekind_create_screen.dart';
import 'bekind_claim_screen.dart';

class BeKindScreen extends StatelessWidget {
  const BeKindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 253, 245, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.orange),
        title: const Text(
          'BE KIND',
          style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const BeKindHeaderBanner(),
              const SizedBox(height: 24),
              BeKindMenuTile(
                icon: Icons.card_giftcard,
                title: 'Buat BE KIND',
                subtitle: 'Bagikan saldo ke teman-temanmu',
                color: const Color.fromARGB(255, 220, 237, 193),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BeKindCreateScreen()),
                ),
              ),
              const SizedBox(height: 12),
              BeKindMenuTile(
                icon: Icons.redeem,
                title: 'Klaim BE KIND',
                subtitle: 'Masukkan kode untuk klaim saldo',
                color: const Color.fromARGB(255, 255, 224, 130),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BeKindClaimScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}