import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'dashboard_screen.dart';
import 'topup_pin.dart'; // Ngarah ke variabel globalUserPin

class CreatePinPage extends StatefulWidget {
  final String userName;

  const CreatePinPage({super.key, required this.userName});

  @override
  State<CreatePinPage> createState() => _CreatePinPageState();
}

class _CreatePinPageState extends State<CreatePinPage> {
  // Controller & FocusNode untuk 6 kotak input PIN
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

  void _savePinAndContinue() {
    String enteredPin = _pinControllers.map((c) => c.text).join();

    if (enteredPin.length < 6) {
      setState(() {
        _errorMessage = "PIN transaksi harus berisi 6 digit angka!";
      });
      return;
    }

    // Peringatan Keamanan jika PIN terlalu simpel
    if (enteredPin == "123456" || enteredPin == "000000" || enteredPin == "111111") {
      setState(() {
        _errorMessage = "PIN terlalu mudah ditebak! Pilih kombinasi angka lain.";
      });
      return;
    }

    // Simpan PIN ke memori global untuk dipake saat Top Up
    globalUserPin = enteredPin;

    // Lanjut masuk ke Dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(userName: widget.userName),
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
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 171, 75, 37)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.security_rounded,
                size: 70,
                color: AppColors.orange,
              ),
              const SizedBox(height: 16),
              Text(
                'Halo ${widget.userName}!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Buat 6 digit PIN transaksi baru untuk mengamankan pembayaran & Top Up di aplikasi kamu.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 32),

              // 6 Box Input PIN Transaksi
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
                        setState(() => _errorMessage = "");

                        if (val.isNotEmpty) {
                          if (index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          } else {
                            _focusNodes[index].unfocus();
                          }
                        } else {
                          if (index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        }
                      },
                    ),
                  );
                }),
              ),

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

              const SizedBox(height: 30),

              // Box Edukasi Keamanan ala E-Wallet
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 248, 225),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color.fromARGB(255, 255, 224, 130)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: AppColors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tips: Jangan berikan PIN transaksi kamu kepada siapa pun, termasuk pihak pengelola aplikasi.',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Tombol Simpan PIN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _savePinAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenBtn,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Simpan PIN & Lanjut',
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
      ),
    );
  }
}