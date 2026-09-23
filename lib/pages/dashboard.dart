import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/colors.dart';
import 'welcome.dart';    // ← ganti dari 'login.dart'

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  UserModel? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final u = await AuthService.getCurrentUser();
    if (!mounted) return;
    setState(() {
      _user = u;
      _loading = false;
    });
  }

  Future<void> _logout() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (konfirmasi != true) return;
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),  // ✅ Welcome
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppColors.greenBtn,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.orange),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, ${_user!.namaLengkap} 🐾',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(221, 192, 102, 12),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Selamat datang di dashboard',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.greenBtn,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Akun',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  _infoRow('Nama', _user!.namaLengkap),
                  _infoRow('User ID', _user!.userId),
                  _infoRow('No. Rekening', _user!.noRekening),
                  _infoRow('NIK', _user!.nik),
                  _infoRow('No. HP', _user!.noHp),
                  _infoRow('Email', _user!.email ?? '-'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: const Column(
                children: [
                  Icon(Icons.dashboard_customize_outlined,
                      size: 48, color: Colors.black26),
                  SizedBox(height: 12),
                  Text(
                    'Fitur lainnya segera hadir',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ini nanti bagian stesa, aku buat simple tolong nanai di buat kayak yang di canva ya ',
                    style: TextStyle(fontSize: 12, color: Colors.black38),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          const Text(': ',
              style: TextStyle(fontSize: 13, color: Colors.black54)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}