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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton('All'),
        _buildButton('Top Up'),
        _buildButton('Transfer'),
      ],
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