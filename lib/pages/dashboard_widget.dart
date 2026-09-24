import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'topup_method.dart';
import 'history_screen.dart';

class DashboardWidget extends StatelessWidget {
  final String userName;
  const DashboardWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 253, 245, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Header Banner Kucing & Name
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 224, 130),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                      'Hello, $userName',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.orange,
                        letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -35,
                    left: 20,
                    child: Image.asset(
                      'assets/images/cat.png',
                      height: 50,
                      errorBuilder: (_, __, ___) => const Icon(Icons.pets, color: AppColors.orange, size: 40),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Menu Grid (6 Tombol)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuItem(
                    context: context,
                    icon: Icons.arrow_upward,
                    label: 'Top Up',
                    color: const Color.fromARGB(255, 255, 224, 130),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TopUpMethodPage()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.swap_horiz,
                    label: 'Transfer',
                    color: const Color.fromARGB(255, 220, 237, 193),
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.attach_money,
                    label: 'Balance',
                    color: const Color.fromARGB(255, 255, 224, 130),
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.history,
                    label: 'History',
                    color: const Color.fromARGB(255, 220, 237, 193),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HistoryScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.favorite,
                    label: 'BE KIND',
                    color: const Color.fromARGB(255, 255, 224, 130),
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.person,
                    label: 'Pawrofile',
                    color: const Color.fromARGB(255, 220, 237, 193),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Bottom Quick Action / Barcode Box
              Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 220, 237, 193),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  size: 40,
                  color: AppColors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget buat ngebikin item menu grid
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.orange, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}