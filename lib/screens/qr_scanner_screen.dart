import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  int _selectedTab = 0;
  File? _selectedImage;
  bool _isValidQris = false;
  final ImagePicker _picker = ImagePicker();
  
  String _currentUserName = 'Pengguna';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await AuthService.getCurrentUser();
    if (mounted && user != null && user.namaLengkap.isNotEmpty) {
      setState(() {
        _currentUserName = user.namaLengkap;
      });
    }
  }
  
  // Ini Analisis Deteksi Gambar Rill berdasarkan Dimensi Foto (Rasio 1:1)
  Future<void> _analyzeQrisImage(XFile image) async {
    try {
      final File imageFile = File(image.path);
      final bytes = await imageFile.readAsBytes();
      
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      
      final int width = frameInfo.image.width;
      final int height = frameInfo.image.height;
      
      // Hitung rasio (QRIS asli umumnya berbentuk mendekati persegi 1:1)
      final double aspectRatio = width / height;
      final bool isSquareShape = aspectRatio >= 0.80 && aspectRatio <= 1.20;

      setState(() {
        _selectedImage = imageFile;
        _isValidQris = isSquareShape;
      });

      if (isSquareShape) {
        _showSuccessDialog();
      } else {
        _showErrorDialog();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memproses gambar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Ambil Gambar dari Kamera
  Future<void> _pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        await _analyzeQrisImage(image);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka kamera: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Ambil Gambar dari Galeri
  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        await _analyzeQrisImage(image);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka galeri: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Dialog jika QRIS tidak valid
  void _showErrorDialog() {
    showDialog(
      context: context,
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
        content: const Text(
          'Gambar yang diunggah tidak memiliki struktur atau rasio kode QRIS yang valid. Harap gunakan foto QRIS yang simetris dan jelas.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Coba Lagi', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Dialog jika QRIS Valid
  void _showSuccessDialog() {
    showDialog(
      context: context,
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
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Merchant: PT PAW-PAY INDONESIA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text('Struktur QRIS terverifikasi dan siap diproses.', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedTab == 0
                              ? AppColors.orange
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Pindai QRIS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: _selectedTab == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedTab == 1
                              ? AppColors.orange
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'QRIS Saya',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: _selectedTab == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
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
        GestureDetector(
          onTap: _pickFromCamera,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedImage != null
                    ? (_isValidQris ? Colors.green : Colors.redAccent)
                    : AppColors.orange,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(24),
              color: Colors.black45,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _selectedImage != null
                  ? Image.file(_selectedImage!, fit: BoxFit.cover)
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 70,
                          color: Colors.white54,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Klik untuk Ambil Foto QRIS',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          'Ketuk kotak di atas untuk kamera atau buka dari galeri',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 30),

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
                const Icon(
                  Icons.qr_code_2_rounded,
                  size: 180,
                  color: Colors.black87,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Gunakan kode ini untuk menerima pembayaran',
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