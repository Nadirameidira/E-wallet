import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 171, 75, 37)),
        title: const Text(
          'History',
          style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const HistorySummary(),
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
                child: HistoryList(filter: selectedFilter),
              ),
            ],
          ),
        ),
      ),
    );
  }
}