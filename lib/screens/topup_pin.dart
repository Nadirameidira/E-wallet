import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'topup_receipt.dart';

// Variabel PIN global dinamis
String globalUserPin = "123456";

class TopUpPinPage extends StatefulWidget {
  final String methodName;
  final int adminFee;
  final int amount;

  const TopUpPinPage({
    super.key,
    required this.methodName,
    required this.adminFee,
    required this.amount,
  });

  @override
  State<TopUpPinPage> createState() => _TopUpPinPageState();
}

class _TopUpPinPageState extends State<TopUpPinPage> {
  // Controller dan FocusNode untuk 6 kotak PIN
  final List<TextEditingController> _pinControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String _errorMessage = "";

  @override
  void dispose() {
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verifyPin() {
    // Gabungkan teks dari ke-6 kotak
    String enteredPin = _pinControllers.map((c) => c.text).join();

    if (enteredPin.length < 6) {
      setState(() {
        _errorMessage = "Harap isi 6 digit PIN secara lengkap!";
      });
      return;
    }

    // Cek ke PIN dinamis yang disimpan dari login
    if (enteredPin == globalUserPin) {
      // PIN Benar -> Masuk ke Struk
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TopUpReceiptPage(
            methodName: widget.methodName,
            adminFee: widget.adminFee,
            amount: widget.amount,
          ),
        ),
      );
    } else {
      // PIN Salah -> Munculkan notifikasi & reset isi kotak
      setState(() {
        _errorMessage = "PIN yang kamu masukkan salah. Silakan coba lagi!";
        for (var controller in _pinControllers) {
          controller.clear();
        }
        // Kembalikan fokus ke kotak pertama
        _focusNodes[0].requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 253, 245, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 171, 75, 37)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Masukkan PIN Kamu',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.orange,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Konfirmasi keamanan transaksi Top Up',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // 6 Box Input PIN Interaktif
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  height: 55,
                  child: TextField(
                    controller: _pinControllers[index],
                    focusNode: _focusNodes[index],
                    autofocus: index == 0,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 224, 130),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() => _errorMessage = ""); // Hapus error pas mengetik

                      if (val.isNotEmpty) {
                        // Jika terisi, otomatis pindah ke kotak kanan
                        if (index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else {
                          // Jika kotak ke-6 terisi, hilangkan keyboard
                          _focusNodes[index].unfocus();
                        }
                      } else {
                        // Jika dihapus (kosong), otomatis mundur ke kotak kiri
                        if (index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      }
                    },
                  ),
                );
              }),
            ),

            // Tampilan Pesan Error jika PIN Salah
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Lupa PIN
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('PIN transaksi kamu saat ini: $globalUserPin'),
                  ),
                );
              },
              child: const Text(
                'Lupa PIN?',
                style: TextStyle(
                  color: AppColors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Spacer(),

            // Tombol Konfirmasi Pembayaran
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _verifyPin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenBtn,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Bayar Sekarang',
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
    );
  }
}