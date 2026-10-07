import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/colors.dart';
import '../utils/formatter.dart';

class HistorySummary extends StatelessWidget {
  final List<Transaction> transactions;

  const HistorySummary({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    int totalIn = 0;
    int totalOut = 0;

    for (var t in transactions) {
      if (t.type == 'Top Up' || t.title.contains('Klaim')) {
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
                'Rp ${formatRupiah(totalIn)}',
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
                'Rp ${formatRupiah(totalOut)}',
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