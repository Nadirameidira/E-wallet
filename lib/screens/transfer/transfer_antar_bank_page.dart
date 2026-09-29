import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/colors.dart';
import '../../widgets/transfer_pin_dialog.dart';

class TransferAntarBankPage extends StatefulWidget {
  const TransferAntarBankPage({super.key});

  @override
  State<TransferAntarBankPage> createState() => _TransferAntarBankPageState();
}

class _TransferAntarBankPageState extends State<TransferAntarBankPage> {
  final _bankTujuanController = TextEditingController();
  final _nominalController = TextEditingController();
  final _beritaController = TextEditingController();

  String? _selectedTujuan;
  final List<String> _tujuanList = [
    'Investasi',
    'Pembayaran Bisnis',
    'Pembelian Barang',
    'Keluarga & Teman',
    'Lainnya',
  ];

  String? _selectedLayanan;
  final List<String> _layananList = [
    'BI-FAST (Rp 2.500)',
    'Realtime Online (Rp 6.500)',
    'SKN / LLG (Rp 2.900)',
  ];

  @override
  void dispose() {
    _bankTujuanController.dispose();
    _nominalController.dispose();
    _beritaController.dispose();
    super.dispose();
  }

  void _validateAndProcess() {
    final bank = _bankTujuanController.text.trim();
    final nominalStr = _nominalController.text.trim();

    if (bank.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan Bank Tujuan terlebih dahulu!')),
      );
      return;
    }

    final nominal = int.tryParse(nominalStr) ?? 0;
    if (nominal < 10000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal transfer adalah Rp 10.000')),
      );
      return;
    }

    if (_selectedTujuan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih Tujuan Transaksi!')),
      );
      return;
    }

    if (_selectedLayanan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih Layanan Transaksi!')),
      );
      return;
    }

    int adminFee = _selectedLayanan!.contains('BI-FAST') ? 2500 : 6500;

    showTransferPinDialog(
      context: context,
      title: 'Transfer $bank',
      amount: nominal,
      adminFee: adminFee,
      type: 'Transfer',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text(
          'Antar Bank',
          style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.orange),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildTextField(
              label: 'Bank Tujuan',
              controller: _bankTujuanController,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: 'Nominal',
              controller: _nominalController,
              isNumber: true,
            ),
            const SizedBox(height: 16),

            // Dropdown Tujuan Transaksi
            _buildDropdownField(
              label: 'Tujuan Transaksi',
              value: _selectedTujuan,
              items: _tujuanList,
              onChanged: (val) => setState(() => _selectedTujuan = val),
            ),
            const SizedBox(height: 16),

            // Dropdown Layanan Transaksi
            _buildDropdownField(
              label: 'Layanan Transaksi',
              value: _selectedLayanan,
              items: _layananList,
              onChanged: (val) => setState(() => _selectedLayanan = val),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: 'Berita',
              controller: _beritaController,
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
      decoration: InputDecoration(
        labelText: label,
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
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      icon: const Icon(Icons.arrow_drop_down, color: AppColors.orange, size: 28),
      dropdownColor: AppColors.bg,
      decoration: InputDecoration(
        labelText: label,
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
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: const TextStyle(color: AppColors.orange)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}