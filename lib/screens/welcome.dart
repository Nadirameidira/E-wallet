import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'login.dart';
import 'register.dart';
import 'info.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const double catLebar = 220;
  static const double kucingTurun = 20;
  static const double jarakKucingTombol = 17;
  static const double posisiDariBawah = 180;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 236, 226),
      body: Stack(
        children: [
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

          Positioned(
            top: 90,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'C',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFCC5B2A),
                      letterSpacing: 1.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Image.asset(
                      'assets/images/paw.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Text(
                    '(sh)t',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFCC5B2A),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: posisiDariBawah,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: Offset(0, kucingTurun),
                  child: Image.asset(
                    'assets/images/cat.png',
                    width: catLebar,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: jarakKucingTombol),

                _tombol(
                  text: 'LOGIN',
                  color: const Color.fromARGB(255, 196, 215, 170),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                ),
                const SizedBox(height: 16),

                _tombol(
                  text: 'REKENING BARU',
                  color: const Color.fromARGB(255, 251, 229, 119),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                ),
                const SizedBox(height: 16),

                _tombol(
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

  Widget _tombol({
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