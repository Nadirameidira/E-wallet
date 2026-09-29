import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'transfer_antar_rekening_page.dart';
import 'transfer_antar_bank_page.dart';
import 'transfer_va_page.dart';

class TransferMenuPage extends StatelessWidget {
  const TransferMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text(
          'Transfer',
          style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.orange),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildTransferMenuItem(
                context: context,
                icon: Icons.swap_horiz_rounded,
                title: 'Antar Rekening',
                subtitle: 'Transfer ke sesama rekening CatPay',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TransferAntarRekeningPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildTransferMenuItem(
                context: context,
                icon: Icons.account_balance_rounded,
                title: 'Antar Bank',
                subtitle: 'Transfer ke rekening bank lain',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TransferAntarBankPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildTransferMenuItem(
                context: context,
                icon: Icons.credit_card_rounded,
                title: 'Bank Virtual Account',
                subtitle: 'Bayar Tagihan Virtual Account (VA)',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TransferVAPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransferMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 248, 225),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(255, 255, 224, 130)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.greenBtn,
          radius: 24,
          child: Icon(icon, color: AppColors.orange, size: 26),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColors.orange,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }
}