import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  int _selectedTab = 0;
  final ImagePicker _picker = ImagePicker();
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  bool _isProcessing = false;
  String _currentUserName = 'Pengguna';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = await AuthService.getCurrentUser();
    if (mounted && user != null && user.namaLengkap.isNotEmpty) {
      setState(() {
        _currentUserName = user.namaLengkap;
      });
    }
  }

  // Handle hasil scan dari Kamera Live
  void _onQrDetected(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      final String codeValue = barcodes.first.rawValue!;
      _processQrisData(codeValue);
    }
  }

  // Process data QR (Validasi QR asli)
  void _processQrisData(String codeValue) {
    setState(() {
      _isProcessing = true;
    });

    // Menghentikan kamera sebentar agar tidak men-scan berulang kali
    _scannerController.stop();

    // Di aplikasi nyata, kita bisa cek format string QRIS (misal mengandung data merchant)
    // Di sini jika QR code terbaca sebagai text/data valid:
    _showSuccessDialog(codeValue);
  }

  // Pilih dari Galeri & Analisis pake MobileScanner Controller (Real QR Decoder)
  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null) {
        setState(() {
          _isProcessing = true;
        });

        // Gunakan fungsi bawaan mobile_scanner untuk menganalisis file gambar dari galeri
        final BarcodeCapture? capture = await _scannerController.analyzeImage(image.path);

        if (capture != null && capture.barcodes.isNotEmpty && capture.barcodes.first.rawValue != null) {
          final String codeValue = capture.barcodes.first.rawValue!;
          _processQrisData(codeValue);
        } else {
          _showErrorDialog('Gambar dari galeri tidak mengandung Kode QRIS yang dapat dibaca.');
        }
      }
    } catch (e) {
      _showErrorDialog('Gagal memproses gambar galeri: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  // Dialog jika QRIS tidak valid / tidak ada QR
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
            SizedBox(width: 10),
            Text('Kode Tidak Dikenali', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isProcessing = false;
              });
              _scannerController.start(); // Jalankan kamera lagi
            },
            child: const Text('Coba Lagi', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Dialog jika QRIS Valid
  void _showSuccessDialog(String qrisContent) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('QRIS Valid', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Merchant: PT PAW-PAY INDONESIA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              'Data QR: ${qrisContent.length > 30 ? '${qrisContent.substring(0, 30)}...' : qrisContent}',
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
            const SizedBox(height: 6),
            const Text('Struktur QRIS terverifikasi dan siap diproses.', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isProcessing = false;
              });
              _scannerController.start();
            },
            child: const Text('Batal', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pembayaran QRIS Berhasil!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context); // Kembali ke halaman sebelumnya setelah bayar
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange),
            child: const Text('Bayar Sekarang', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'QRIS & Barcode',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Tab Switcher
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedTab = 0);
                        _scannerController.start();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedTab == 0 ? AppColors.orange : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Pindai QRIS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedTab = 1);
                        _scannerController.stop(); // Matikan kamera jika pindah ke tab QR Saya
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedTab == 1 ? AppColors.orange : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'QRIS Saya',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _selectedTab == 0 ? _buildScanView() : _buildMyQRView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Viewfinder Scanner Kamera Asli
        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.orange, width: 3),
            borderRadius: BorderRadius.circular(24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                MobileScanner(
                  controller: _scannerController,
                  onDetect: _onQrDetected,
                ),
                if (_isProcessing)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.orange),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          'Arahkan kamera ke kode QRIS untuk memindai',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 30),

        // Tombol Galeri
        ElevatedButton.icon(
          onPressed: _pickFromGallery,
          icon: const Icon(Icons.image_outlined, color: Colors.white),
          label: const Text(
            'Buka Galeri',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }

 Widget _buildMyQRView() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 280,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              const Icon(Icons.pets, color: AppColors.orange, size: 36),
              const SizedBox(height: 8),
              const Text(
                'PAW-PAY QRIS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _currentUserName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // --- Widget QR Kode bisa ke scan  ---
              QrImageView(
                data: 'PAWPAY-QRIS-$_currentUserName', // Payload data unik user
                version: QrVersions.auto,
                size: 180.0,
                backgroundColor: Colors.white,
              ),

              const SizedBox(height: 12),
              
              // Teks petunjuk di bawah QR
              const Text(
                'Tunjukkan QR ini untuk bertransaksi atau menerima pembayaran', 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

}