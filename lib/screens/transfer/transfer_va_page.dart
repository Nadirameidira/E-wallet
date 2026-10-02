import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/colors.dart';
import '../../widgets/transfer_pin_dialog.dart';

class TransferVAPage extends StatefulWidget {
  const TransferVAPage({super.key});

  @override
  State<TransferVAPage> createState() => _TransferVAPageState();
}

class _TransferVAPageState extends State<TransferVAPage> {
  final _vaController = TextEditingController();

  @override
  void dispose() {
    _vaController.dispose();
    super.dispose();
  }

  void _validateAndProcess() {
    final va = _vaController.text.trim();

    if (va.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nomor Virtual Account yang valid!')),
      );
      return;
    }

    // Default tagihan simulasi Virtual Account
    showTransferPinDialog(
      context: context,
      title: 'Virtual Account $va',
      amount: 50000,
      adminFee: 0,
      type: 'Transfer',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text(
          'Bank Virtual Account',
          style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.orange),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _vaController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Masukkan Virtual Account',
                labelStyle: const TextStyle(color: AppColors.orange),
                fillColor: const Color.fromARGB(255, 255, 248, 225),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.orange, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 255, 224, 130)),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenBtn,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: _validateAndProcess,
                child: const Text(
                  'Kirim',
                  style: TextStyle(
                    color: AppColors.orange,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}