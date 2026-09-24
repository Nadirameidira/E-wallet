import 'package:flutter/material.dart';
import '../services/transaction_data.dart';
import '../utils/colors.dart';

class HistorySummary extends StatelessWidget {
  const HistorySummary({super.key});

  @override
  Widget build(BuildContext context) {
    int totalIn = 0;
    int totalOut = 0;

    for (var t in historyList) {
      if (t.type == 'Top Up') {
        totalIn += t.total;
      } else {
        totalOut += t.total;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greenBtn,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Text(
                'Income',
                style: TextStyle(color: Colors.green, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                'Rp $totalIn',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.orange,
                ),
              ),
            ],
          ),
          Container(width: 1, height: 40, color: Colors.white),
          Column(
            children: [
              const Text(
                'Expense',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                'Rp $totalOut',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}