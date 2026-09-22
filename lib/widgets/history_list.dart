import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_data.dart';
import 'history_empty.dart';
import 'history_item.dart';

class HistoryList extends StatelessWidget {
  final String filter;

  const HistoryList({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    List<Transaction> filteredList = historyList;

    if (filter != 'All') {
      filteredList = historyList.where((t) => t.type == filter).toList();
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