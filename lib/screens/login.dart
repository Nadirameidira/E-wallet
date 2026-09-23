import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'create_pin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.orange,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Email needd to be filled' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _password,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'need to be filled' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String rawInput = _email.text.split('@').first;

                      // 1. Hapus semua angka
                      String noNumbers = rawInput.replaceAll(RegExp(r'[0-9]'), '');

                      // 2. Ganti pemisah karakter (. _ -) jadi spasi
                      String withSpaces = noNumbers.replaceAll(RegExp(r'[\._-]'), ' ');

                      // 3. PISAHKAN SUKU KATA / NAMA DEMPET 
                      // Memisah huruf kapital 
                      // atau menyisipkan spasi sebelum vokal jika berupa gabungan kata
                      String formatted = withSpaces.replaceAllMapped(
                        RegExp(r'(?<=[a-z])(?=[A-Z])'), 
                        (Match m) => ' '
                      );

                      // 4. Ubah tiap kata jadi Huruf Kapital di Awal (Title Case)
                      String cleanName = formatted
                          .split(' ')
                          .where((word) => word.isNotEmpty)
                          .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
                          .join(' ');

                      if (cleanName.isEmpty) cleanName = 'User';           

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreatePinPage(userName: cleanName),
                            ),
                       );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenBtn,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: AppColors.orange),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}