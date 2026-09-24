import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _nik = TextEditingController();
  final _noHp = TextEditingController();
  final _email = TextEditingController();
  final _userId = TextEditingController();
  final _password = TextEditingController();
  final _pin = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nama.dispose();
    _nik.dispose();
    _noHp.dispose();
    _email.dispose();
    _userId.dispose();
    _password.dispose();
    _pin.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final user = UserModel(
      userId: _userId.text.trim(),
      namaLengkap: _nama.text.trim(),
      nik: _nik.text.trim(),
      noRekening: UserModel.generateNoRekening(),
      noHp: _noHp.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
      pin: _pin.text,
    );

    final ok = await AuthService.register(user);
    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: const Text('Registrasi Berhasil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Akun kamu sudah dibuat.'),
              const SizedBox(height: 12),
              const Text('User ID:',
                  style: TextStyle(fontSize: 12, color: Colors.black54)),
              Text(
                user.userId,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(height: 8),
              const Text('No. Rekening:',
                  style: TextStyle(fontSize: 12, color: Colors.black54)),
              Text(
                user.noRekening,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK',
                  style: TextStyle(color: AppColors.orange)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User ID sudah terdaftar, coba yang lain'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'DAFTAR AKUN BARU',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.orange,
                  ),
                ),
                const SizedBox(height: 24),

                // === Data Diri ===
                _sectionTitle('Data Diri'),
                CustomTextField(controller: _nama, label: 'Nama Lengkap'),
                CustomTextField(
                  controller: _nik,
                  label: 'NIK (16 digit)',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'NIK wajib diisi';
                    if (v.length != 16) return 'NIK harus 16 digit';
                    if (!RegExp(r'^\d+$').hasMatch(v)) {
                      return 'NIK harus angka';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _noHp,
                  label: 'No. HP',
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'No. HP wajib diisi';
                    if (v.length < 10) return 'No. HP tidak valid';
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _email,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email wajib diisi';
                    if (!v.contains('@')) return 'Email tidak valid';
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // === Akun ===
                _sectionTitle('Akun'),
                CustomTextField(
                  controller: _userId,
                  label: 'User ID (untuk login)',
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'User ID wajib diisi';
                    if (v.length < 4) return 'Minimal 4 karakter';
                    if (v.contains(' ')) return 'Tidak boleh ada spasi';
                    return null;
                  },
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
                CustomTextField(
                  controller: _pin,
                  label: 'PIN (6 digit angka)',
                  keyboardType: TextInputType.number,
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'PIN wajib diisi';
                    if (v.length != 6) return 'PIN harus 6 digit';
                    if (!RegExp(r'^\d+$').hasMatch(v)) {
                      return 'PIN harus angka';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 8),
                CustomButton(
                  text: _loading ? 'Memproses...' : 'DAFTAR',
                  color: AppColors.greenBtn,
                  horizontalPadding: 0,
                  onTap: _loading ? null : _submit,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 8),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}