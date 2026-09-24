import 'package:flutter/material.dart';

class HistoryEmpty extends StatelessWidget {
  const HistoryEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 70, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'Belum ada transaksi',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Yuk mulai Top Up pertama kamu!',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }
}