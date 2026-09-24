import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/colors.dart';
import 'dashboard_screen.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  String _pin = '';
  bool _error = false;

  void _onDigitTap(String digit) {
    if (_pin.length >= 6) return;
    setState(() {
      _pin += digit;
      _error = false;
    });
    if (_pin.length == 6) _verify();
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _error = false;
    });
  }

  Future<void> _verify() async {
    final ok = await AuthService.verifyPin(_pin);
    if (!mounted) return;

    if (ok) {
      
      final user = await AuthService.getCurrentUser();
      if (!mounted) return;

      final userName = user?.namaLengkap ?? 'User';

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(userName: userName),
        ),
      );
    } else {
      setState(() {
        _error = true;
        _pin = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN salah, coba lagi'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 253, 245, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 171, 75, 37)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                'Masukkan PIN',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error ? 'PIN salah, coba lagi' : 'Masukkan 6 digit PIN kamu',
                style: TextStyle(
                  color: _error ? Colors.red : Colors.black54,
                ),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) {
                  final filled = i < _pin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? AppColors.orange : Colors.transparent,
                      border: Border.all(color: AppColors.orange, width: 2),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1.6,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    ...List.generate(9, (i) {
                      final n = (i + 1).toString();
                      return _keypadButton(n, () => _onDigitTap(n));
                    }),
                    const SizedBox(),
                    _keypadButton('0', () => _onDigitTap('0')),
                    _keypadButton('⌫', _onBackspace, isIcon: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _keypadButton(String text, VoidCallback onTap, {bool isIcon = false}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isIcon ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: AppColors.orange,
            ),
          ),
        ),
      ),
    );
  }
}