import 'dart:io';
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
  final ImagePicker _picker = ImagePicker();
  
  // Tujuannya untuk menampung nama pengguna yang sedang aktif/login
  String _currentUserName = 'Pengguna';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Mengambil nama user yang terautentikasi secara dinamis dari AuthService
  // Mengambil data pengguna yang sedang login dari AuthService
  Future<void> _loadUserData() async {
    final user = await AuthService.getCurrentUser();
    if (mounted) {
      if (user != null && user.namaLengkap.isNotEmpty) {
        setState(() {
          _currentUserName = user.namaLengkap;
        });
      } else {
        // Jika SharedPreferences kosong, disini lakukan debug print untuk mengecek di console
        print("DEBUG QRIS: Data user dari AuthService bernilai null");
      }
    }
  }

  // Fungsi async untuk membuka galeri penyimpanan perangkat
  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gambar QRIS berhasil dimuat!'),
            backgroundColor: AppColors.orange,
          ),
        );
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

            // Tab Switcher Navigasi
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

  // Tampilan 1: Pindai / Unggah dari Galeri
  Widget _buildScanView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.orange, width: 3),
            borderRadius: BorderRadius.circular(24),
            color: Colors.black45,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _selectedImage != null
                ? Image.file(_selectedImage!, fit: BoxFit.cover)
                : const Center(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 80,
                      color: Colors.white24,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 20),

        Text(
          _selectedImage != null
              ? 'Foto QRIS siap diproses'
              : 'Arahkan kamera ke QRIS atau ambil dari galeri',
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 30),

        ElevatedButton.icon(
          onPressed: _pickFromGallery,
          icon: const Icon(Icons.photo_library_rounded, color: Colors.white),
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

  // Tampilan 2: QRIS Pengguna (Dinamis sesuai Akun Active)
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
                
                // Menampilkan nama user yang aktif secara dinamis
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

                // Teks petunjuk
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