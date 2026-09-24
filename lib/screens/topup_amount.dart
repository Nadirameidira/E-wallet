import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'topup_pin.dart';

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
  // Nampung angka yang lagi diketik sama user
  String _amountStr = '0';

  // Logika tombol kalkulator pas ditekan
  void _onKeyPress(String val) {
    setState(() {
      if (val == 'CLEAR') {
        // Hapus angka paling belakang satu per satu
        if (_amountStr.length > 1) {
          _amountStr = _amountStr.substring(0, _amountStr.length - 1);
        } else {
          _amountStr = '0';
        }
      } else if (val == '000') {
        // Nambahin nol tiga biji sekaligus asal Layar bukan '0'
        if (_amountStr != '0') {
          _amountStr += '000';
        }
      } else {
        // Kalo masih nol, ganti. Kalo udah ada angka, tempel di belakangnya
        if (_amountStr == '0') {
          _amountStr = val;
        } else {
          _amountStr += val;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int amount = int.tryParse(_amountStr) ?? 0;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 253, 245, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 171, 75, 37)),
        title: Text(
          widget.methodName,
          style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Box layar tempat munculnya nominal yang diketik
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 224, 130),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Nominal Top Up',
                    style: TextStyle(color: AppColors.orange, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp $_amountStr',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange,
                    ),
                  ),
                ],
              ),
            ),
            
            const Spacer(),

            // Section keypad numpad kalkulator bawah
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 238, 231, 208),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  _buildKeypadRow(['1', '2', '3']),
                  _buildKeypadRow(['4', '5', '6']),
                  _buildKeypadRow(['7', '8', '9']),
                  _buildKeypadRow(['000', '0', 'CLEAR']),
                  const SizedBox(height: 16),
                  
                  // Tombol lanjut, baru aktif kalo nominal minimal Rp10.000
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: amount < 10000
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TopUpPinPage(
                                    methodName: widget.methodName,
                                    adminFee: widget.adminFee,
                                    amount: amount,
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenBtn,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Konfirmasi Nominal',
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

  // Widget bantuan buat bikin 1 baris tombol keypad
  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: InkWell(
              onTap: () => _onKeyPress(key),
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 253, 245, 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: key == 'CLEAR'
                      ? const Icon(Icons.backspace_outlined, color: AppColors.orange)
                      : Text(
                          key,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.orange,
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}