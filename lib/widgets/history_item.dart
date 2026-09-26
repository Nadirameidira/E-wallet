import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/colors.dart';

class HistoryItem extends StatelessWidget {
  final Transaction transaction;

  const HistoryItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    bool isIncome = transaction.type == 'Top Up';

    return Card(
      color: const Color.fromARGB(255, 255, 248, 225),
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color.fromARGB(255, 255, 224, 130)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome ? AppColors.greenBtn : AppColors.bg,
          child: Icon(
            isIncome ? Icons.arrow_upward : Icons.swap_horiz,
            color: AppColors.orange,
            size: 20,
          ),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          transaction.date,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Text(
          '${isIncome ? '+' : '-'}Rp ${transaction.total}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}