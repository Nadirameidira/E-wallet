import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../services/bekind_service.dart';
import '../services/auth_service.dart';
import '../services/balance_service.dart';
import '../services/transaction_data.dart';
import '../models/transaction_model.dart';
import '../widgets/bekind_input_field.dart';
import '../widgets/bekind_primary_button.dart';
import '../widgets/bekind_code_card.dart';

class BeKindCreateScreen extends StatefulWidget {
  const BeKindCreateScreen({super.key});

  @override
  State<BeKindCreateScreen> createState() => _BeKindCreateScreenState();
}

class _BeKindCreateScreenState extends State<BeKindCreateScreen> {
  final _amountCtrl = TextEditingController();
  final _slotsCtrl = TextEditingController(text: '1');
  final _messageCtrl = TextEditingController();
  bool _loading = false;
  String? _generatedCode;

  Future<void> _create() async {
    final amount = int.tryParse(_amountCtrl.text) ?? 0;
    final slots = int.tryParse(_slotsCtrl.text) ?? 0;

    if (amount < 1000 || slots < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal Rp1.000 dan 1 penerima')),
      );
      return;
    }

    final balance = await BalanceService.getBalance();
    if (balance < amount) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saldo kamu tidak mencukupi!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final pinOk = await _askPin();
    if (pinOk != true) return;

    setState(() => _loading = true);

    final user = await AuthService.getCurrentUser();
    final creatorName = user?.namaLengkap ?? 'User';

    await BalanceService.deductBalance(amount);

    final bekind = await BeKindService.create(
      creatorName: creatorName,
      amount: amount,
      slots: slots,
      message: _messageCtrl.text.isEmpty
          ? 'Semoga dapat bermanfaat 🐾'
          : _messageCtrl.text,
    );

    final now = DateTime.now();
    historyList.add(Transaction(
      title: 'BE KIND - Buat (${bekind.code})',
      amount: amount,
      adminFee: 0,
      type: 'Transfer',
      date: '${now.day}/${now.month}/${now.year}',
    ));

    if (!mounted) return;
    setState(() {
      _loading = false;
      _generatedCode = bekind.code;
    });
  }

  Future<bool?> _askPin() async {
    final pinCtrl = TextEditingController();
    bool loading = false;
    String error = '';

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setSt) {
          Future<void> submit() async {
            if (pinCtrl.text.length < 6) {
              setSt(() => error = 'PIN harus 6 digit');
              return;
            }
            setSt(() {
              loading = true;
              error = '';
            });

            final ok = await AuthService.verifyPin(pinCtrl.text);

            if (!dialogCtx.mounted) return;

            if (!ok) {
              setSt(() {
                loading = false;
                error = 'PIN salah!';
                pinCtrl.clear();
              });
              return;
            }

            Navigator.pop(dialogCtx, true);
          }

          return Dialog(
            backgroundColor: const Color.fromRGBO(255, 253, 245, 1),
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Masukkan 6 digit PIN untuk konfirmasi',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: pinCtrl,
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
                      counterText: '',
                      filled: true,
                      fillColor: const Color(0xFFFFE082),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: AppColors.orange, width: 2),
                      ),
                    ),
                  ),
                  if (error.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      error,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenBtn,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                        ),
                      ),
                      onPressed: loading ? null : submit,
                      child: loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.orange,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Konfirmasi',
                              style: TextStyle(
                                color: AppColors.orange,
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
          'Buat BE KIND',
          style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: _generatedCode == null ? _buildForm() : _buildResult(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        BeKindInputField(
          label: 'Nominal Total (Rp)',
          controller: _amountCtrl,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        BeKindInputField(
          label: 'Jumlah Penerima',
          controller: _slotsCtrl,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        BeKindInputField(
          label: 'Pesan (opsional)',
          controller: _messageCtrl,
        ),
        const SizedBox(height: 30),
        BeKindPrimaryButton(
          label: 'Buat BE KIND',
          loading: _loading,
          onPressed: _create,
        ),
      ],
    );
  }

  Widget _buildResult() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Icon(Icons.pets, color: AppColors.orange, size: 60),
        const SizedBox(height: 12),
        const Text(
          'BE KIND Berhasil Dibuat!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.orange,
          ),
        ),
        const SizedBox(height: 24),
        BeKindCodeCard(code: _generatedCode!),
        const SizedBox(height: 24),
        BeKindPrimaryButton(
          label: 'Selesai',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}