import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'pin.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userId = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _userId.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final user = await AuthService.loginStep1(
      _userId.text.trim(),
      _password.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PinPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User ID atau Password salah'),
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
            const IconThemeData(color: Color(0xFFAB4B25)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Halaman Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Masukkan User ID dan Password kamu',
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 32),

                CustomTextField(
                  controller: _userId,
                  label: 'User ID',
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'User ID wajib diisi' : null,
                ),
                CustomTextField(
                  controller: _password,
                  label: 'Password',
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password wajib diisi';
                    if (v.length < 6) return 'Minimal 6 karakter';
                    return null;
                  },
                ),

                const SizedBox(height: 8),
                CustomButton(
                  text: _loading ? 'Memuat...' : 'LOGIN',
                  color: AppColors.greenBtn,
                  horizontalPadding: 0,
                  onTap: _loading ? null : _login,
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum punya akun? ',
                        style: TextStyle(color: Color(0xFFAB4B25))),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterPage()),
                      ),
                      child: const Text(
                        'Daftar Sekarang',
                        style: TextStyle(
                          color: AppColors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}