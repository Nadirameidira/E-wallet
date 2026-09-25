import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';
import 'topup_method.dart';
import 'history_screen.dart';
import 'welcome.dart';

class DashboardScreen extends StatelessWidget {
  final String userName;
  const DashboardScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 253, 245, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.pets, color: AppColors.orange),
            tooltip: 'Log Out',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
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
                    top: -48,
                    left: 20,
                    child: Image.asset(
                      'assets/images/cat.png',
                      height: 50,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.pets,
                        color: AppColors.orange,
                        size: 40,
                      ),
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
                        MaterialPageRoute(
                            builder: (_) => const TopUpMethodPage()),
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
                        MaterialPageRoute(
                            builder: (_) => const HistoryScreen()),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: const Color.fromRGBO(255, 253, 245, 1),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _boingPaw(delayMs: 0, size: 36, angle: -0.3),
                  const SizedBox(width: 6),
                  _boingPaw(delayMs: 120, size: 56, angle: 0),
                  const SizedBox(width: 6),
                  _boingPaw(delayMs: 240, size: 36, angle: 0.3),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Want to leave, Meow? 🐾',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You sure to logout?\ndont forget tocheck ur ca(sh)t anytime sooner !',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 220, 237, 193),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Stay here',
                        style: TextStyle(
                          color: AppColors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        await AuthService.logout();
                        if (!context.mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const WelcomePage()),
                          (route) => false,
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 224, 130),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pets,
                              size: 16, color: AppColors.orange),
                          SizedBox(width: 6),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: AppColors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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

  Widget _boingPaw({
    required int delayMs,
    required double size,
    required double angle,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 700 + delayMs),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: angle,
          child: Transform.scale(
            scale: value,
            child: child,
          ),
        );
      },
      child: Icon(
        Icons.pets,
        size: size,
        color: AppColors.orange,
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