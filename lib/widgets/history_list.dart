import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'history_empty.dart';
import 'history_item.dart';

class HistoryList extends StatelessWidget {
  final List<Transaction> transactions;
  final String filter;

  const HistoryList({
    super.key,
    required this.transactions,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    List<Transaction> filteredList = transactions;

    if (filter != 'All') {
      filteredList = transactions.where((t) => t.type == filter).toList();
    }

    if (filteredList.isEmpty) {
      return const HistoryEmpty();
    }

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return HistoryItem(transaction: filteredList[index]);
      },
    );
  }
}