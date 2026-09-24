import 'package:flutter/material.dart';
import '../utils/colors.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        titleTextStyle: const TextStyle(
          color: AppColors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        backgroundColor: AppColors.greenBtn,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.orange),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section(
              icon: Icons.info_outline,
              title: 'Tentang Aplikasi',
              content: const Text(
                'Aplikasi ini adalah dompet digital sederhana yang dirancang '
                'untuk mempermudah transaksi harian Anda. Dibangun dengan '
                'konsep yang sederhana, aman, dan mudah digunakan.\n\n'
                'Versi: 1.0.0',
                style: TextStyle(height: 1.6, color: AppColors.orange),
              ),
            ),

            const SizedBox(height: 16),

            _section(
              icon: Icons.gavel,
              title: 'Syarat & Ketentuan',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _TnCItem(
                    nomor: '1',
                    judul: 'Pendaftaran Akun',
                    isi:
                        'Pengguna wajib memberikan informasi yang akurat, meliputi '
                        'nama lengkap, KTP, nomor telepon, dan alamat email yang valid.',
                  ),
                  _TnCItem(
                    nomor: '2',
                    judul: 'Keamanan Akun',
                    isi:
                        'Pengguna bertanggung jawab penuh untuk menjaga kerahasiaan '
                        'User ID, Password, dan PIN. Jangan bagikan kepada siapa pun.',
                  ),
                  _TnCItem(
                    nomor: '3',
                    judul: 'Penggunaan Layanan',
                    isi:
                        'Aplikasi hanya boleh digunakan untuk transaksi yang sah. '
                        'Segala bentuk kecurangan akan dilaporkan ke pihak berwenang.',
                  ),
                  _TnCItem(
                    nomor: '4',
                    judul: 'Privasi Data',
                    isi:
                        'Data pribadi pengguna dilindungi dan hanya digunakan untuk '
                        'keperluan penyediaan layanan aplikasi.',
                  ),
                  _TnCItem(
                    nomor: '5',
                    judul: 'Perubahan Ketentuan',
                    isi:
                        'Kami berhak mengubah Syarat & Ketentuan ini sewaktu-waktu. '
                        'Perubahan akan diumumkan di dalam aplikasi.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _section(
              icon: Icons.support_agent,
              title: 'Bantuan & Kontak',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _ContactRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: 'support@ca(sh)t.id',
                  ),
                  _ContactRow(
                    icon: Icons.phone_outlined,
                    label: 'Call Center',
                    value: '6688-6174',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Center(
              child: Text(
                '© 2026 Ca(sh)t',
                style: TextStyle(fontSize: 11, color: AppColors.darkG),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.darkG),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }
}

class _TnCItem extends StatelessWidget {
  final String nomor;
  final String judul;
  final String isi;

  const _TnCItem({
    required this.nomor,
    required this.judul,
    required this.isi,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: AppColors.greenBtn,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                nomor,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.orange,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isi,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: AppColors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.darkG),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(fontSize: 13, color: AppColors.orange)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkG)),
        ],
      ),
    );
  }
}