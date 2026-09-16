// register.dart
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: const Center(child: Text('Halaman Rekening Baru')),
    );
  }
}