import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../services/bekind_service.dart';
import '../services/auth_service.dart'; 
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

    setState(() => _loading = true);

    final user = await AuthService.getCurrentUser();
    final creatorName = user?.namaLengkap ?? 'User';

    final bekind = await BeKindService.create(
      creatorName: creatorName,
      amount: amount,
      slots: slots,
      message: _messageCtrl.text.isEmpty
          ? 'Semoga dapat bermanfaat 🐾'
          : _messageCtrl.text,
    );

    if (!mounted) return;
    setState(() {
      _loading = false;
      _generatedCode = bekind.code;
    });
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