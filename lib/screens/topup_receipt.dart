import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import '../services/transaction_data.dart';
import '../models/transaction_model.dart';
import '../services/balance_service.dart';
import '../services/auth_service.dart'; 
import 'dashboard_screen.dart';

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

  // Helper fungsi untuk memformat angka jadi format rupiah (misal: 13500 -> Rp 13.500)
  String _formatRupiah(int number) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    // Pengambilan tanggal dan waktu transaksi saat ini
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}/${now.month}/${now.year}";
    String formattedTime = "${now.hour}:${now.minute.toString().padLeft(2, '0')} WIB";
    int total = amount + adminFee;

    return Scaffold(
      // Warna latar belakang krem halus agar konsisten dengan halaman Transfer
      backgroundColor: const Color(0xFFFAF8EE),
      body: SafeArea(
        child: Stack(
          children: [
            // 1. DEKORASI BACKGROUND (PAW KUCING)
            // Paw Kucing Kiri Atas
            Positioned(
              top: 30,
              left: 20,
              child: Icon(
                Icons.pets,
                size: 70,
                color: const Color(0xFFE8DCC4).withValues(alpha: 0.5),
              ),
            ),
            // Paw Kucing Kanan Atas
            Positioned(
              top: 110,
              right: 15,
              child: Icon(
                Icons.pets,
                size: 85,
                color: const Color(0xFFE8DCC4).withValues(alpha: 0.5),
              ),
            ),
            // Paw Kucing Kiri Bawah
            Positioned(
              bottom: 80,
              left: 30,
              child: Icon(
                Icons.pets,
                size: 75,
                color: const Color(0xFFE8DCC4).withValues(alpha: 0.5),
              ),
            ),

            // 2. KONTEN RESI UTAMA
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Ikon Status Berhasil (Centang Hijau)
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF4CAF50), size: 80),
                  const SizedBox(height: 12),
                  // Judul Transaksi Berhasil
                  const Text(
                    'Top Up Berhasil!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 3. KARTU RINCIAN STRUK / DETAIL TRANSAKSI
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      // Warna background dan border disamakan persis dengan Transfer agar konsisten
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFFE082)),
                    ),
                    child: Column(
                      children: [
                        _buildRow('Tanggal', formattedDate),
                        _buildRow('Waktu', formattedTime),
                        _buildRow('Metode Pembayaran', methodName),
                        const Divider(height: 24, thickness: 1, color: Color(0xFFE0E0E0)),
                        _buildRow('Nominal Top Up', _formatRupiah(amount)),
                        _buildRow('Biaya Admin', adminFee == 0 ? 'Bebas Admin' : _formatRupiah(adminFee)),
                        const Divider(height: 24, thickness: 1, color: Color(0xFFE0E0E0)),
                        _buildRow('Total Pembayaran', _formatRupiah(total), isBold: true),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // 4. TOMBOL KEMBALI KE BERANDA
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Memasukkan data transaksi baru ke dalam riwayat
                        historyList.add(
                          Transaction(
                            title: 'Top Up $methodName',
                            amount: amount,
                            adminFee: adminFee,
                            type: 'Top Up',
                            date: formattedDate,
                          ),
                        );
                        
                        // Menambahkan nominal ke saldo akun pengguna secara async
                        await BalanceService.addBalance(amount);
                        if (!context.mounted) return;

                        // Ambil nama pengguna aktif dari AuthService
                        final user = await AuthService.getCurrentUser();
                        final userName = user?.namaLengkap ?? 'User';

                        if (!context.mounted) return;

                        // Navigasi kembali ke DashboardScreen dan hapus riwayat tumpukan halaman
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DashboardScreen(userName: userName),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC5E1A5), // Warna hijau tombol
                        elevation: 0,
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
          ],
        ),
      ),
    );
  }

  // HELPER COMPONENT UNTUK BARIS STRUK
  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label Kiri
          Text(
            label, 
            style: TextStyle(
              color: isBold ? AppColors.orange : Colors.grey[700], 
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 8),
          // Nilai Kanan (Dibungkus Flexible agar teks panjang tidak memicu overflow)
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: isBold ? AppColors.orange : Colors.black,
                fontSize: isBold ? 16 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}