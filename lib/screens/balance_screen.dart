import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';
import 'topup_method.dart';
import 'transfer/transfer_menu_page.dart';
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
  // Menampung riwayat transaksi user yang lagi login, buat ditampilin preview
  List<Transaction> _allTransactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _openPage(Widget page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
    if (!mounted) return;
    _loadData();
  }

  Future<void> _loadData() async {
    final balance = await BalanceService.getBalance();
    final user = await AuthService.getCurrentUser();

    // Ambil riwayat transaksi khusus milik user yang aktif
    List<Transaction> all = [];
    if (user != null) {
      all = await TransactionService.getHistory(user.userId);
    }

    if (!mounted) return;
    setState(() {
      _balance = balance;
      _noRekening = user?.noRekening ?? '-';
      _namaLengkap = user?.namaLengkap ?? '-';
      _allTransactions = all;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ambil 5 transaksi terbaru (karena list udah urut terbaru di depan)
    final recentTransactions = _allTransactions.take(5).toList();

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
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFE082),
                              foregroundColor: AppColors.orange,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () => _openPage(const TopUpMethodPage()),
                            icon: const Icon(Icons.arrow_upward_rounded, size: 18),
                            label: const Text(
                              'Top Up',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greenBtn,
                              foregroundColor: AppColors.orange,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () => _openPage(const TransferMenuPage()),
                            icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                            label: const Text(
                              'Transfer',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
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
                    // Kirim daftar transaksi user ke widget summary
                    HistorySummary(transactions: _allTransactions),
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