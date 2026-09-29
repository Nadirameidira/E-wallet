import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import '../../services/auth_service.dart';
import '../../services/balance_service.dart';
import '../../services/transaction_data.dart';
import '../../utils/colors.dart';
import '../screens/transfer/transfer_receipt_page.dart'; // <--- Import Struk Transfer

void showTransferPinDialog({
  required BuildContext context,
  required String title,
  required int amount,
  required int adminFee,
  required String type,
}) {
  final pinController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> handleSend() async {
            if (pinController.text.length < 6) {
              setState(() {
                errorMessage = 'PIN harus 6 digit angka';
              });
              return;
            }

            setState(() {
              isLoading = true;
              errorMessage = '';
            });

            // 1. Verifikasi PIN
            final isPinValid = await AuthService.verifyPin(pinController.text);

            if (!isPinValid) {
              setState(() {
                isLoading = false;
                errorMessage = 'PIN yang kamu masukkan salah!';
                pinController.clear();
              });
              return;
            }

            // 2. Cek Saldo
            final currentBalance = await BalanceService.getBalance();
            final totalDeduction = amount + adminFee;

            if (currentBalance < totalDeduction) {
              setState(() {
                isLoading = false;
                errorMessage = 'Saldo kamu tidak mencukupi!';
              });
              return;
            }

            // 3. Potong Saldo
            await BalanceService.deductBalance(totalDeduction);

            // 4. Buat objek Transaksi & Simpan ke Riwayat
            DateTime now = DateTime.now();
            String formattedDate = "${now.day}/${now.month}/${now.year}";

            final newTransaction = Transaction(
              title: title,
              amount: amount,
              adminFee: adminFee,
              type: type,
              date: formattedDate,
            );

            // Ambil user aktif untuk dapat userId
            final currentUser = await AuthService.getCurrentUser();
            if (currentUser != null) {
              await TransactionService.addTransaction(currentUser.userId, newTransaction);
            }

            if (!dialogContext.mounted) return;
            Navigator.pop(dialogContext); // Tutup Dialog PIN

            // 5. Navigasi langsung ke Halaman Bukti Transfer
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => TransferReceiptPage(
                  transaction: newTransaction,
                ),
              ),
            );
          }

          return Dialog(
            backgroundColor: AppColors.bg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'PIN TRANSAKSI',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Masukkan 6 digit PIN untuk mengonfirmasi transfer',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: pinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      letterSpacing: 8,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange,
                    ),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      hintStyle: TextStyle(
                        color: AppColors.orange.withValues(alpha: 0.4),
                        letterSpacing: 6,
                      ),
                      counterText: '',
                      fillColor: const Color(0xFFFFE082),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.orange, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (_) {
                      if (errorMessage.isNotEmpty) {
                        setState(() => errorMessage = '');
                      }
                    },
                  ),

                  if (errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenBtn,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: isLoading ? null : handleSend,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.orange,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Kirim',
                              style: TextStyle(
                                color: AppColors.orange,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}