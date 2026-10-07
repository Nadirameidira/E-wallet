import 'package:flutter/material.dart';
import '../utils/colors.dart';

class HistoryFilter extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const HistoryFilter({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildButton('All'),
          const SizedBox(width: 8),
          _buildButton('Payment'),
          const SizedBox(width: 8),
          _buildButton('Top Up'),
          const SizedBox(width: 8),
          _buildButton('Transfer'),
          const SizedBox(width: 8),
          _buildButton('BE KIND'),
        ],
      ),
    );
  }

  Widget _buildButton(String label) {
    bool isActive = selectedFilter == label;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? AppColors.bg : Colors.grey[300],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        onFilterChanged(label);
      },
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? AppColors.orange : Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}