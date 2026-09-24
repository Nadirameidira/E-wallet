import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'topup_amount.dart';

class TopUpMethodPage extends StatelessWidget {
  const TopUpMethodPage({super.key});

  // Pengelompokan pilihan bank, e-wallet, dan retail biar rapi
  final Map<String, List<Map<String, dynamic>>> _methodCategories = const {
    'Transfer Bank': [
      {'name': 'BCA Virtual Account', 'fee': 0, 'icon': Icons.account_balance},
      {'name': 'Mandiri VA', 'fee': 1000, 'icon': Icons.account_balance},
      {'name': 'BRI VA', 'fee': 1000, 'icon': Icons.account_balance},
      {'name': 'BNI VA', 'fee': 1000, 'icon': Icons.account_balance},
      {'name': 'Bank Permata', 'fee': 1000, 'icon': Icons.account_balance},
    ],
    'E-Wallet': [
      {'name': 'ShopeePay', 'fee': 1000, 'icon': Icons.account_balance_wallet},
      {'name': 'DANA', 'fee': 1000, 'icon': Icons.account_balance_wallet},
      {'name': 'OVO', 'fee': 1000, 'icon': Icons.account_balance_wallet},
      {'name': 'GoPay', 'fee': 1000, 'icon': Icons.account_balance_wallet},
    ],
    'Retail / Minimarket': [
      {'name': 'Indomaret', 'fee': 2500, 'icon': Icons.store},
      {'name': 'Alfamart', 'fee': 2500, 'icon': Icons.store},
      {'name': 'Alfamidi', 'fee': 2500, 'icon': Icons.store},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 253, 245, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 171, 75, 37)),
        title: const Text(
          'Metode Top Up',
          style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        // Loop tiap kategori yang ada di Map di atas
        children: _methodCategories.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul kategori (misal: Transfer Bank)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.orange,
                  ),
                ),
              ),
              // List metode di dalam kategori tersebut
              ...entry.value.map((method) {
                int fee = method['fee'];
                String feeText = fee == 0 ? 'Bebas Admin' : 'Biaya Admin: Rp $fee';

                return Card(
                  color: const Color.fromARGB(255, 255, 248, 225),
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color.fromARGB(255, 255, 224, 130)),
                  ),
                  child: ListTile(
                    leading: Icon(method['icon'], color: AppColors.orange),
                    title: Text(
                      method['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      feeText,
                      style: TextStyle(
                        color: fee == 0 ? Colors.green : Colors.grey[700],
                        fontSize: 12,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.orange),
                    // Kalo diklik, lempar nama metode & biaya adminnya ke halaman ketik nominal
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TopUpAmountPage(
                            methodName: method['name'],
                            adminFee: method['fee'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ),
    );
  }
}