import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onTap;
  final double height;
  final double horizontalPadding;

  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
    this.height = 56,
    this.horizontalPadding = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.orange,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}