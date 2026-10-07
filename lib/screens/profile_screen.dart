import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/colors.dart';
import 'welcome.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;
  File? _selectedImageFile;
  bool _isNotificationEnabled = true;

  // Daftar asset avatar lokal
  final List<String> _catAvatarAssets = [
    'assets/images/profilecat1.png',
    'assets/images/profilecat2.png',
    'assets/images/profilecat3.png',
    'assets/images/profilecat4.png',
    'assets/images/proilecat5.png',
  ];

  late String _selectedCatAsset;

  @override
  void initState() {
    super.initState();
    _selectedCatAsset = _catAvatarAssets[0];
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);
    final user = await AuthService.getCurrentUser();

    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  void _showAvatarOptionsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ubah Foto Profil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE082),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library, color: AppColors.orange),
                ),
                title: const Text('Pilih dari Album / Galeri', style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImageFile = File(pickedFile.path);
                    });
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Foto profil berhasil diperbarui! 🐾')),
                    );
                  }
                },
              ),
              const Divider(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Atau Pilih Avatar Kucing:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.7)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 75,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _catAvatarAssets.length,
                  itemBuilder: (context, index) {
                    final catAsset = _catAvatarAssets[index];
                    final isSelected = _selectedCatAsset == catAsset && _selectedImageFile == null;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCatAsset = catAsset;
                          _selectedImageFile = null;
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Avatar kucing berhasil dipilih! 🐾')),
                        );
                      },
                      child: Container(
                        width: 65,
                        height: 65,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE082),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.orange : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            catAsset,
                            fit: BoxFit.cover,
                            width: 65,
                            height: 65,
                            errorBuilder: (ctx, err, stack) => const Icon(Icons.pets, color: AppColors.orange),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showDataDiriDialog() {
    final nama = _user?.namaLengkap ?? '';
    final userId = _user?.userId ?? '';
    final noRek = _user?.noRekening ?? '';
    final noHp = _user?.noHp ?? '';
    final nik = _user?.nik ?? '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 248, 225),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.person, color: AppColors.orange),
            SizedBox(width: 8),
            Text(
              'Data Diri',
              style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataRow('Nama Lengkap', nama),
            _buildDataRow('User ID', '@$userId'),
            _buildDataRow('NIK', nik),
            _buildDataRow('No. HP', noHp),
            _buildDataRow('No. Rekening', noRek),
            _buildDataRow('Status', 'Terverifikasi 🐾'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.black.withOpacity(0.54))),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.orange),
          ),
        ],
      ),
    );
  }

  void _showGantiPinModal() {
    final pinLamaController = TextEditingController();
    final pinBaruController = TextEditingController();
    String errorMsg = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'GANTI PIN TRANSAKSI',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.orange),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: pinLamaController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: 'PIN Saat Ini',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: pinBaruController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: 'PIN Baru (6 Digit)',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  if (errorMsg.isNotEmpty) ...[
                    Text(errorMsg, style: const TextStyle(color: Colors.red, fontSize: 12)),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenBtn,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () async {
                        if (pinLamaController.text.length < 6 || pinBaruController.text.length < 6) {
                          setStateModal(() => errorMsg = 'PIN harus 6 digit angka!');
                          return;
                        }

                        final isValid = await AuthService.verifyPin(pinLamaController.text);
                        if (!isValid) {
                          setStateModal(() => errorMsg = 'PIN saat ini salah!');
                          return;
                        }

                        await AuthService.updatePin(pinBaruController.text);

                        if (!ctx.mounted) return;
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('PIN Transaksi berhasil diperbarui! 🐾')),
                        );
                      },
                      child: const Text('Simpan PIN Baru', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showNotifikasiModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pengaturan Notifikasi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.orange),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.orange,
                    title: const Text('Notifikasi Transaksi', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Terima pemberitahuan saat ada saldo masuk atau keluar', style: TextStyle(fontSize: 12)),
                    value: _isNotificationEnabled,
                    onChanged: (val) {
                      setState(() {
                        _isNotificationEnabled = val;
                      });
                      setStateModal(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showBantuanDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 248, 225),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.help_outline_rounded, color: AppColors.orange),
            SizedBox(width: 8),
            Text(
              'Pusat Bantuan',
              style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ada kendala dengan transaksi CatPay?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.email_outlined, color: AppColors.orange),
              title: const Text('Email CS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              subtitle: const Text('support@cat(sh)t.id', style: TextStyle(fontSize: 12)),
              onTap: () {},
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.phone_in_talk_outlined, color: AppColors.orange),
              title: const Text('Call Center', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              subtitle: const Text('6688-6174 (Jam Operasional 08.00 - 17.00)', style: TextStyle(fontSize: 12)),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 248, 225),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar Akun', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
        content: const Text('Apakah kamu yakin ingin keluar dari akun ini? 🐾'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await AuthService.logout();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomePage()),
                (route) => false,
              );
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: CircularProgressIndicator(color: AppColors.orange)),
      );
    }

    // ambil dari data user yang login
    final nama = _user?.namaLengkap ?? '';
    final userId = _user?.userId ?? '';
    final noRek = _user?.noRekening ?? '';

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'PAWROFILE',
          style: TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          // foto profil/avatar
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: _showAvatarOptionsModal,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFE082),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: _selectedImageFile != null
                          ? Image.file(_selectedImageFile!, fit: BoxFit.cover)
                          : Image.asset(
                              _selectedCatAsset,
                              fit: BoxFit.cover,
                              width: 110,
                              height: 110,
                              errorBuilder: (ctx, err, stack) => const Icon(Icons.pets, size: 60, color: AppColors.orange),
                            ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _showAvatarOptionsModal,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // card info pengguna
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nama,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '@$userId',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE082),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Terverifikasi 🐾',
                        style: TextStyle(
                          color: AppColors.orange,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white30, height: 24),
                
                // no rekening dan salin rekeningnya
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'No. Rekening CatPay',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        Text(
                          noRek,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE082),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: noRek));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('No. Rekening ($noRek) berhasil disalin! 🐾')),
                        );
                      },
                      icon: const Icon(Icons.copy_rounded, color: AppColors.orange, size: 16),
                      label: const Text(
                        'Salin',
                        style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // list menu
          _buildMenuButton(
            icon: Icons.person,
            label: 'Data diri',
            color: const Color.fromARGB(255, 230, 240, 210),
            onTap: _showDataDiriDialog,
          ),
          _buildMenuButton(
            icon: Icons.lock_rounded,
            label: 'Ganti PIN',
            color: const Color(0xFFFFE082),
            onTap: _showGantiPinModal,
          ),
          _buildMenuButton(
            icon: Icons.notifications_rounded,
            label: 'Notifikasi',
            color: const Color.fromARGB(255, 230, 240, 210),
            onTap: _showNotifikasiModal,
          ),
          _buildMenuButton(
            icon: Icons.help_rounded,
            label: 'Bantuan',
            color: const Color(0xFFFFE082),
            onTap: _showBantuanDialog,
          ),
          const SizedBox(height: 12),

          // logout
          _buildMenuButton(
            icon: Icons.logout_rounded,
            label: 'Keluar Akun',
            color: const Color(0xFFFFEBEE),
            textColor: Colors.redAccent,
            onTap: _showLogoutDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required Color color,
    Color textColor = AppColors.orange,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: textColor, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: textColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}