import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';
import '../services/balance_service.dart';
import '../services/transaction_data.dart';
import '../widgets/balance_card.dart';
import '../widgets/history_summary.dart';
import '../widgets/history_item.dart';
import '../widgets/history_empty.dart';
import 'history_screen.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  int _balance = 0;
  String _noRekening = '-';
  String _namaLengkap = '-';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final balance = await BalanceService.getBalance();
    final user = await AuthService.getCurrentUser();
    if (!mounted) return;
    setState(() {
      _balance = balance;
      _noRekening = user?.noRekening ?? '-';
      _namaLengkap = user?.namaLengkap ?? '-';
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final recentTransactions = historyList.reversed.take(5).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.orange),
        title: const Text(
          'Balance',
          style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.orange),
            )
          : RefreshIndicator(
              color: AppColors.orange,
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BalanceCard(
                      balance: _balance,
                      noRekening: _noRekening,
                    ),
                    const SizedBox(height: 16),

                    // Nama pemilik rekening
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 248, 225),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color.fromARGB(255, 255, 224, 130)),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: AppColors.greenBtn,
                            child: Icon(Icons.pets, color: AppColors.orange),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pemilik Rekening',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _namaLengkap,
                                style: const TextStyle(
                                  color: AppColors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Ringkasan pemasukan & pengeluaran
                    const Text(
                      'Ringkasan',
                      style: TextStyle(
                        color: AppColors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const HistorySummary(),
                    const SizedBox(height: 24),

                    // Transaksi Terakhir + tombol lihat semua
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Transaksi Terakhir',
                          style: TextStyle(
                            color: AppColors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HistoryScreen()),
                            );
                          },
                          child: const Text(
                            'Lihat Semua',
                            style: TextStyle(
                              color: AppColors.orange,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    recentTransactions.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: HistoryEmpty(),
                          )
                        : Column(
                            children: recentTransactions
                                .map((t) => HistoryItem(transaction: t))
                                .toList(),
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}