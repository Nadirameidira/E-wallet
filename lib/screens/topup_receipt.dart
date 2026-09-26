import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../services/transaction_data.dart';
import '../models/transaction_model.dart';
import '../services/balance_service.dart';

class TopUpReceiptPage extends StatelessWidget {
  final String methodName;
  final int adminFee;
  final int amount;

  const TopUpReceiptPage({
    super.key,
    required this.methodName,
    required this.adminFee,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}/${now.month}/${now.year}";
    String formattedTime = "${now.hour}:${now.minute.toString().padLeft(2, '0')} WIB";
    int total = amount + adminFee;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 253, 245, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 80),
              const SizedBox(height: 12),
              const Text(
                'Top Up Berhasil!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(height: 30),

              // Rincian Struk Pembayaran
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 248, 225),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color.fromARGB(255, 255, 224, 130)),
                ),
                child: Column(
                  children: [
                    _buildRow('Tanggal', formattedDate),
                    _buildRow('Waktu', formattedTime),
                    _buildRow('Metode Pembayaran', methodName),
                    const Divider(height: 24, thickness: 1),
                    _buildRow('Nominal Top Up', 'Rp $amount'),
                    _buildRow('Biaya Admin', adminFee == 0 ? 'Bebas Admin' : 'Rp $adminFee'),
                    const Divider(height: 24, thickness: 1),
                    _buildRow('Total Pembayaran', 'Rp $total', isBold: true),
                  ],
                ),
              ),
              const Spacer(),

              // Tombol Kembali ke Dashboard Utama
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async{
                  // Simpan transaksi ke History sebelum kembali
                    historyList.add(
                      Transaction(
                        title: 'Top Up $methodName',
                        amount: amount,
                        adminFee: adminFee,
                        type: 'Top Up',
                        date: formattedDate,
                      ),
                    );
                  // Tambahin nominal top up kesaldo user
                  await BalanceService.addBalance(amount);
                  if (!context.mounted) return;
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenBtn,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(
                      color: AppColors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: TextStyle(
              color: isBold ? AppColors.orange : Colors.grey[700], 
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? AppColors.orange : Colors.black,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}