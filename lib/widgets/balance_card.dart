import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/formatter.dart';

/// Kartu saldo yang muncul di Dashboard, gayanya nyamain sama komponen
/// lain di app ini (rounded 20, warna cream/oranye/kuning, aksen kucing).
class BalanceCard extends StatefulWidget {
  final int balance;
  final String noRekening;
  final VoidCallback? onRefresh;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.noRekening,
    this.onRefresh,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isHidden = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.orange,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Paw print dekorasi transparan di pojok kanan atas, cuma pemanis
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.pets,
              size: 90,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris label "Saldo Kamu" + tombol mata buat sembunyiin saldo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.pets, size: 14, color: Colors.white70),
                      SizedBox(width: 6),
                      Text(
                        'Saldo Kamu',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => setState(() => _isHidden = !_isHidden),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        _isHidden
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        size: 20,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Nominal saldo gede di tengah
              Text(
                _isHidden ? 'Rp •••••••' : 'Rp ${formatRupiah(widget.balance)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 18),

              // Garis putus2 pemisah, biar kesan kayak struk/kartu rekening
              const _DashedDivider(),
              const SizedBox(height: 14),

              // No. rekening di bagian bawah kartu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'No. Rekening',
                        style: TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.noRekening,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'CATPAY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget kecil buat bikin garis putus-putus horizontal
class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 6.0;
        const dashSpace = 4.0;
        final dashCount =
            (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
        return Row(
          children: List.generate(dashCount, (_) {
            return Padding(
              padding: const EdgeInsets.only(right: dashSpace),
              child: Container(
                width: dashWidth,
                height: 1,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            );
          }),
        );
      },
    );
  }
}
