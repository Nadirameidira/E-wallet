import 'package:flutter/material.dart';
import '../utils/colors.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Info'),
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
              title: 'About the App',
              content: const Text(
                'This app is a simple digital wallet designed to make your '
                'daily transactions easier. Built with a simple, secure, and '
                'user-friendly concept.\n\n'
                'Version: 1.0.0',
                style: TextStyle(height: 1.6, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 16),

            _section(
              icon: Icons.gavel,
              title: 'Terms & Conditions',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _TnCItem(
                    nomor: '1',
                    judul: 'Account Registration',
                    isi:
                        'Users must provide accurate information, including full '
                        'name, national ID, phone number, and a valid email address.',
                  ),
                  _TnCItem(
                    nomor: '2',
                    judul: 'Account Security',
                    isi:
                        'Users are fully responsible for keeping their User ID, '
                        'Password, and PIN confidential. Do not share them with anyone.',
                  ),
                  _TnCItem(
                    nomor: '3',
                    judul: 'Use of Service',
                    isi:
                        'The app may only be used for legitimate transactions. '
                        'Any form of fraud will be reported to the authorities.',
                  ),
                  _TnCItem(
                    nomor: '4',
                    judul: 'Data Privacy',
                    isi:
                        'Users\' personal data is protected and used solely for '
                        'the purpose of providing app services.',
                  ),
                  _TnCItem(
                    nomor: '5',
                    judul: 'Changes to Terms',
                    isi:
                        'We reserve the right to change these Terms & Conditions '
                        'at any time. Changes will be announced in the app.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _section(
              icon: Icons.support_agent,
              title: 'Help & Contact',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _ContactRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: 'support@aplikasi.id',
                  ),
                  _ContactRow(
                    icon: Icons.phone_outlined,
                    label: 'Call Center',
                    value: '1500-123',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Center(
              child: Text(
                '© 2025 Aplikasi Indonesia',
                style: TextStyle(fontSize: 11, color: Colors.black45),
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
            color: Colors.black.withAlpha(10),
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
              Icon(icon, size: 20, color: AppColors.orange),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
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
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isi,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: Colors.black54,
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
          Icon(icon, size: 18, color: AppColors.orange),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
        ],
      ),
    );
  }
}