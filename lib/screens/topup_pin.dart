import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
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
  bool _loading = false;

  @override
  void initState() {
    super.initState();
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

  void _onKeypadClick(String val) {
    if (_pinController.text.length < 6) {
      setState(() {
        _pinController.text += val;
      });
    }
  }

  void _onBackspace() {
    if (_pinController.text.isNotEmpty) {
      setState(() {
        _pinController.text =
            _pinController.text.substring(0, _pinController.text.length - 1);
      });
    }
  }

  // FUNGSI SUBMIT DENGAN VALIDASI PIN
  Future<void> _submit() async {
    if (_pinController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan 6 digit PIN lengkap')),
      );
      return;
    }

    setState(() => _loading = true);

    // 1. Ambil data user yang sedang login saat ini
    final currentUser = await AuthService.getCurrentUser();

    if (!mounted) return;
    setState(() => _loading = false);

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesi pengguna tidak ditemukan. Silakan login kembali.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 2. Cocokkan PIN yang diinput dengan PIN akun terdaftar
    if (_pinController.text != currentUser.pin) {
      // PIN Salah -> Kosongkan input & tampilkan pesan error
      setState(() {
        _pinController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN yang kamu masukkan salah! Silakan coba lagi.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 3. Jika PIN Benar -> Lanjut ke Halaman Struk Top Up
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
        toolbarHeight: 40,
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
                      'MEOW PIN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Masukkan 6 digit PIN angka yang kamu daftarkan saat pertama kali registrasi.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 32),

                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(_focusNode);
                      },
                      child: Stack(
                        children: [
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
                                setState(() {});
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              bool isFilled = index < currentPin.length;
                              return Container(
                                width: 38,
                                height: 48,
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
                                          width: 10,
                                          height: 10,
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

            // Keypad
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
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadBtn('4'),
                      _buildKeypadBtn('5'),
                      _buildKeypadBtn('6'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadBtn('7'),
                      _buildKeypadBtn('8'),
                      _buildKeypadBtn('9'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 48),
                      _buildKeypadBtn('0'),
                      SizedBox(
                        width: 48,
                        height: 48,
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

            // Tombol Bayar
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenBtn,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _loading ? 'Memverifikasi...' : 'Bayar Sekarang',
                    style: const TextStyle(
                      fontSize: 15,
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

  Widget _buildKeypadBtn(String val) {
    return SizedBox(
      width: 48,
      height: 48,
      child: TextButton(
        onPressed: () => _onKeypadClick(val),
        child: Text(
          val,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.orange,
          ),
        ),
      ),
    );
  }
}