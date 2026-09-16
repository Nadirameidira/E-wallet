import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'login.dart';
import 'register.dart';
import 'info.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 236, 226),
      body: Stack(
        children: [
          // rumput
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 180,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/grass.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // kucing + tombol (satu grup, diatur dari bawah)
          Positioned(
            left: 0,
            right: 0,
            bottom: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // kucing
                Image.asset(
                  'assets/images/cat.png',
                  width: 220,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 8),

                // LOGIN
                _buildButton(
                  text: 'LOGIN',
                  color: const Color.fromARGB(255, 196, 215, 170),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                ),
                const SizedBox(height: 16),

                // REKENING BARU
                _buildButton(
                  text: 'REKENING BARU',
                  color: const Color.fromRGBO(238, 231, 208, 1),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                ),
                const SizedBox(height: 16),

                // INFO
                _buildButton(
                  text: 'INFO',
                  color: AppColors.greenBtn,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const InfoPage()),
                  ),
                ),
              ],
            ),
          ),

          // icon headset kanan atas
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.support_agent,
                    size: 36,
                    color: AppColors.orange,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.orange,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}