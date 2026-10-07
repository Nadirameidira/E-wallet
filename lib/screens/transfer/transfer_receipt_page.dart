import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import '../../services/auth_service.dart';
import '../../utils/colors.dart';
import '../../utils/formatter.dart';
import '../dashboard_screen.dart';

class TransferReceiptPage extends StatelessWidget {
  final Transaction transaction;

  const TransferReceiptPage({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // background
          Positioned(
            top: 60,
            left: 30,
            child: _AnimatedTransparentPaw(delayMs: 100, size: 40, angle: -0.3),
          ),
          Positioned(
            top: 130,
            right: 40,
            child: _AnimatedTransparentPaw(delayMs: 300, size: 50, angle: 0.2),
          ),
          Positioned(
            top: 260,
            left: 20,
            child: _AnimatedTransparentPaw(delayMs: 500, size: 45, angle: -0.1),
          ),
          Positioned(
            bottom: 180,
            right: 35,
            child: _AnimatedTransparentPaw(delayMs: 700, size: 55, angle: 0.4),
          ),
          Positioned(
            bottom: 90,
            left: 45,
            child: _AnimatedTransparentPaw(delayMs: 900, size: 42, angle: -0.2),
          ),

          // bukti transfer
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Icon Berhasil
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 80,
                  ),
                  const SizedBox(height: 12),
                  
                  const Text(
                    'Transfer Berhasil!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Rincian Struk / Detail Transaksi Transfer
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 248, 225).withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color.fromARGB(255, 255, 224, 130),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildRow('Tanggal', transaction.date),
                        _buildRow('Jenis Transaksi', transaction.type),
                        _buildRow('Tujuan', transaction.title),
                        const Divider(height: 24, thickness: 1),
                        _buildRow(
                          'Nominal Transfer',
                          'Rp ${formatRupiah(transaction.amount)}',
                        ),
                        _buildRow(
                          'Biaya Admin',
                          transaction.adminFee == 0
                              ? 'Bebas Admin'
                              : 'Rp ${formatRupiah(transaction.adminFee)}',
                        ),
                        const Divider(height: 24, thickness: 1),
                        _buildRow(
                          'Total Transaksi',
                          'Rp ${formatRupiah(transaction.total)}',
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Tombol Kembali ke Beranda
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final user = await AuthService.getCurrentUser();
                        final userName = user?.namaLengkap ?? 'User';

                        if (!context.mounted) return;

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DashboardScreen(userName: userName),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenBtn,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
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
        ],
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

// widget paw
class _AnimatedTransparentPaw extends StatelessWidget {
  final int delayMs;
  final double size;
  final double angle;

  const _AnimatedTransparentPaw({
    required this.delayMs,
    required this.size,
    required this.angle,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delayMs)),
      builder: (context, snapshot) {
        bool show = snapshot.connectionState == ConnectionState.done;
        return AnimatedOpacity(
          opacity: show ? 0.18 : 0.0, // Tingkat transparansi paw di latar belakang
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
          child: AnimatedScale(
            scale: show ? 1.0 : 0.2,
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            child: Transform.rotate(
              angle: angle,
              child: Icon(
                Icons.pets,
                size: size,
                color: AppColors.orange,
              ),
            ),
          ),
        );
      },
    );
  }
}