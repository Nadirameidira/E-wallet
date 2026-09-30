import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/colors.dart';
import 'topup_receipt.dart';

class TopUpPinScreen extends StatefulWidget {
  final int amount;
  final String methodName;
  final int adminFee;

  const TopUpPinScreen({
    super.key,
    required this.amount,
    required this.methodName,
    required this.adminFee,
  });

  @override
  State<TopUpPinScreen> createState() => _TopUpPinScreenState();
}

class _TopUpPinScreenState extends State<TopUpPinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Biar pas halaman kebuka, keyboard laptop/HP langsung aktif tanpa klik2 lagi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Handle kalau user ngeklik angka dari keypad buatan di layar
  void _onKeypadClick(String val) {
    if (_pinController.text.length < 6) {
      setState(() {
        _pinController.text += val;
      });
    }
  }

  // Handle tombol hapus di keypad layar
  void _onBackspace() {
    if (_pinController.text.isNotEmpty) {
      setState(() {
        _pinController.text =
            _pinController.text.substring(0, _pinController.text.length - 1);
      });
    }
  }

  void _submit() {
    if (_pinController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan 6 digit PIN lengkap')),
      );
      return;
    }

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => TopUpReceiptPage(
        amount: widget.amount,
        methodName: widget.methodName,
        adminFee: widget.adminFee,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentPin = _pinController.text;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 253, 245, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.orange),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'Masukkan PIN Kamu',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Teks penjelas biar user gak bingung ini PIN apa
                    const Text(
                      'Masukkan 6 digit PIN akun yang kamu daftarkan saat pertama kali registrasi.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Trik Stack: TextField invisibel di balik 6 kotak PIN
                    // Jadi user bisa ngetik dari keyboard laptop, tp kelihatannya ngisi kotak PIN
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(_focusNode);
                      },
                      child: Stack(
                        children: [
                          // TextField tersembunyi buat nangkep pencetan keyboard laptop
                          Opacity(
                            opacity: 0,
                            child: TextField(
                              controller: _pinController,
                              focusNode: _focusNode,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (val) {
                                setState(() {}); // Refresh tampilan kotak tiap ngetik
                              },
                            ),
                          ),
                          
                          // Tampilan visual 6 kotak PIN
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              bool isFilled = index < currentPin.length;
                              return Container(
                                width: 45,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE082),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isFilled
                                        ? AppColors.orange
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: isFilled
                                      ? Container(
                                          width: 12,
                                          height: 12,
                                          decoration: const BoxDecoration(
                                            color: AppColors.orange,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Keypad ala kalkulator di layar (Opsional kalau mau diklik pake mouse)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadBtn('1'),
                      _buildKeypadBtn('2'),
                      _buildKeypadBtn('3'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadBtn('4'),
                      _buildKeypadBtn('5'),
                      _buildKeypadBtn('6'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadBtn('7'),
                      _buildKeypadBtn('8'),
                      _buildKeypadBtn('9'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 60),
                      _buildKeypadBtn('0'),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: IconButton(
                          onPressed: _onBackspace,
                          icon: const Icon(
                            Icons.backspace,
                            color: AppColors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tombol submit transaksi
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenBtn,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Bayar Sekarang',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper button keypad angka layar
  Widget _buildKeypadBtn(String val) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextButton(
        onPressed: () => _onKeypadClick(val),
        child: Text(
          val,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.orange,
          ),
        ),
      ),
    );
  }
}