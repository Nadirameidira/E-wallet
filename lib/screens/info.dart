// info.dart
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: const Center(child: Text('Halaman Info')),
    );
  }
}