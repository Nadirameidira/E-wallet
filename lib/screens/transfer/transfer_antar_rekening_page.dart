import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/colors.dart';
import '../../widgets/transfer_pin_dialog.dart';

class TransferAntarRekeningPage extends StatefulWidget {
  const TransferAntarRekeningPage({super.key});

  @override
  State<TransferAntarRekeningPage> createState() => _TransferAntarRekeningPageState();
}

class _TransferAntarRekeningPageState extends State<TransferAntarRekeningPage> {
  final _rekeningController = TextEditingController();
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

  @override
  void dispose() {
    _rekeningController.dispose();
    _nominalController.dispose();
    _beritaController.dispose();
    super.dispose();
  }

  void _validateAndProcess() {
    final rekening = _rekeningController.text.trim();
    final nominalStr = _nominalController.text.trim();

    if (rekening.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor Rekening Tujuan harus 10 digit!')),
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
        const SnackBar(content: Text('Pilih Tujuan Transaksi terlebih dahulu!')),
      );
      return;
    }

    // Tampilkan Dialog PIN
    showTransferPinDialog(
      context: context,
      title: 'Transfer ke $rekening',
      amount: nominal,
      adminFee: 0, // Bebas biaya admin sesama rekening
      type: 'Transfer',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text(
          'Antar Rekening',
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
            // Rekening Tujuan (Maksimal 10 Digit)
            _buildTextField(
              label: 'Rekening Tujuan',
              controller: _rekeningController,
              isNumber: true,
              maxLength: 10,
            ),
            const SizedBox(height: 16),

            // Nominal
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

            // Berita
            _buildTextField(
              label: 'Berita',
              controller: _beritaController,
            ),
            const SizedBox(height: 32),

            // Tombol Kirim
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
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber
          ? [
              FilteringTextInputFormatter.digitsOnly,
              if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
            ]
          : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.orange),
        counterText: '',
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
      value: value,
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