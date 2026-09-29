import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/auth_service.dart';
import '../services/transaction_data.dart';
import '../utils/colors.dart';
import '../widgets/history_filter.dart';
import '../widgets/history_list.dart';
import '../widgets/history_summary.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedFilter = 'All';
  late Future<List<Transaction>> historyFuture;

  @override
  void initState() {
    super.initState();
    historyFuture = _loadHistory();
  }

  Future<List<Transaction>> _loadHistory() async {
    final user = await AuthService.getCurrentUser();
    if (user == null) return [];
    return TransactionService.getHistory(user.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.orange),
        title: const Text(
          'History',
          style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Transaction>>(
          future: historyFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Gagal memuat riwayat'));
            } else if (snapshot.hasData) {
              final transactions = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    HistorySummary(transactions: transactions),
                    const SizedBox(height: 16),
                    HistoryFilter(
                      selectedFilter: selectedFilter,
                      onFilterChanged: (value) {
                        setState(() {
                          selectedFilter = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: HistoryList(
                        transactions: transactions,
                        filter: selectedFilter,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.orange),
              );
            }
          },
        ),
      ),
    );
  }
}