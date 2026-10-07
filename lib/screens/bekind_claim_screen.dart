import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../services/bekind_service.dart';
import '../services/auth_service.dart';
import '../services/balance_service.dart';
import '../services/transaction_data.dart';
import '../models/transaction_model.dart';
import '../widgets/bekind_input_field.dart';
import '../widgets/bekind_primary_button.dart';

class BeKindClaimScreen extends StatefulWidget {
  const BeKindClaimScreen({super.key});

  @override
  State<BeKindClaimScreen> createState() => _BeKindClaimScreenState();
}

class _BeKindClaimScreenState extends State<BeKindClaimScreen> {
  final _codeCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _claim() async {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;

    setState(() => _loading = true);
    final bekind = await BeKindService.claim(code);
    if (!mounted) return;
    setState(() => _loading = false);

    if (bekind == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode tidak valid atau sudah habis'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final amount = bekind.totalAmount ~/ bekind.totalSlots;

    await BalanceService.addBalance(amount);

    final now = DateTime.now();
    final currentUser = await AuthService.getCurrentUser();
    if (currentUser != null) {
      await TransactionService.addTransaction(
        currentUser.userId,
        Transaction(
          title: 'BE KIND - Klaim (${bekind.code})',
          amount: amount,
          adminFee: 0,
          type: 'BE KIND',
          date: '${now.day}/${now.month}/${now.year}',
        ),
      );
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromRGBO(255, 253, 245, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.pets, color: AppColors.orange),
            SizedBox(width: 8),
            Text('Yeay! 🐾', style: TextStyle(color: AppColors.orange)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kamu berhasil klaim Rp$amount'),
            const SizedBox(height: 8),
            Text(
              'Dari: ${bekind.creatorName}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            if (bekind.message.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 224, 130),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.message,
                        color: AppColors.orange, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        bekind.message,
                        style: const TextStyle(
                          color: AppColors.orange,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK', style: TextStyle(color: AppColors.orange)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 253, 245, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.orange),
        title: const Text(
          'Klaim BE KIND',
          style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.redeem, size: 80, color: AppColors.orange),
              const SizedBox(height: 16),
              const Text(
                'Masukkan kode BE KIND',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(height: 24),
              BeKindInputField(
                label: 'Kode',
                controller: _codeCtrl,
                hintText: 'KIND-XXXX',
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.characters,
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(height: 24),
              BeKindPrimaryButton(
                label: 'Klaim Sekarang',
                loading: _loading,
                onPressed: _claim,
              ),
            ],
          ),
        ),
      ),
    );
  }
}