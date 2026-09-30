import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import 'topup_pin.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) return newValue;

    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    String formatted = formatter.format(double.parse(digitsOnly)).trim();

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class TopUpAmountPage extends StatefulWidget {
  final String methodName;
  final int adminFee;

  const TopUpAmountPage({
    super.key,
    required this.methodName,
    required this.adminFee,
  });

  @override
  State<TopUpAmountPage> createState() => _TopUpAmountPageState();
}

class _TopUpAmountPageState extends State<TopUpAmountPage> {
  final _amountController = TextEditingController();

  String _formatNumberString(String digitsOnly) {
    if (digitsOnly.isEmpty) return '';
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(double.parse(digitsOnly)).trim();
  }

  void _selectPreset(int amount) {
    setState(() {
      _amountController.text = _formatNumberString(amount.toString());
    });
  }

  // Handle klik angka
  void _onKeypadClick(String val) {
    String currentDigits = _amountController.text.replaceAll('.', '');
    if (currentDigits.length < 9) {
      String newDigits = currentDigits + val;
      setState(() {
        _amountController.text = _formatNumberString(newDigits);
      });
    }
  }

  void _onBackspace() {
    String currentDigits = _amountController.text.replaceAll('.', '');
    if (currentDigits.isNotEmpty) {
      String newDigits = currentDigits.substring(0, currentDigits.length - 1);
      setState(() {
        _amountController.text = _formatNumberString(newDigits);
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 253, 245, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Top Up',
          style: TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            children: [
              // Info Metode
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Metode: ${widget.methodName}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // Judul Nominal
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nominal Top Up',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.orange,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Box Input Nominal
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
                decoration: InputDecoration(
                  prefixText: 'Rp ',
                  prefixStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.orange,
                  ),
                  hintText: '0',
                  hintStyle: const TextStyle(color: Colors.black26),
                  filled: true,
                  fillColor: const Color(0xFFFFF7DB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Tombol Preset Nominal Cepat
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _presetButton(20000, 'Rp 20.000'),
                  _presetButton(50000, 'Rp 50.000'),
                  _presetButton(100000, 'Rp 100.000'),
                ],
              ),
              const Spacer(),

              // Keypad Angka
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadBtn('1'),
                      _buildKeypadBtn('2'),
                      _buildKeypadBtn('3'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadBtn('4'),
                      _buildKeypadBtn('5'),
                      _buildKeypadBtn('6'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadBtn('7'),
                      _buildKeypadBtn('8'),
                      _buildKeypadBtn('9'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadBtn('000'), // <--- Tombol 000 biar mempermudah aja sih ini tujuannya pas si user masukin nomialnya
                      _buildKeypadBtn('0'),
                      SizedBox(
                        width: 65,
                        height: 45,
                        child: IconButton(
                          onPressed: _onBackspace,
                          icon: const Icon(
                            Icons.backspace,
                            color: AppColors.orange,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),

              // Tombol Lanjutkan
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    String cleanDigits = _amountController.text.replaceAll('.', '');
                    int amount = int.tryParse(cleanDigits) ?? 0;

                    if (amount < 10000) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Minimal Top Up adalah Rp 10.000'),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TopUpPinScreen(
                          amount: amount,
                          methodName: widget.methodName,
                          adminFee: widget.adminFee,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenBtn,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Lanjutkan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }

  Widget _presetButton(int amount, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: OutlinedButton(
          onPressed: () => _selectPreset(amount),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.orange),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadBtn(String val) {
    return SizedBox(
      width: 65,
      height: 45,
      child: TextButton(
        onPressed: () => _onKeypadClick(val),
        child: Text(
          val,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.orange,
          ),
        ),
      ),
    );
  }
}