class UserModel {
  final String userId;
  final String namaLengkap;
  final String nik;
  final String noRekening;
  final String noHp;
  final String? email;
  final String password;
  final String pin;

  UserModel({
    required this.userId,
    required this.namaLengkap,
    required this.nik,
    required this.noRekening,
    required this.noHp,
    this.email,
    required this.password,
    required this.pin,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'namaLengkap': namaLengkap,
        'nik': nik,
        'noRekening': noRekening,
        'noHp': noHp,
        'email': email,
        'password': password,
        'pin': pin,
      };

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
        userId: j['userId'],
        namaLengkap: j['namaLengkap'],
        nik: j['nik'],
        noRekening: j['noRekening'],
        noHp: j['noHp'],
        email: j['email'],
        password: j['password'],
        pin: j['pin'],
      );

  static String generateNoRekening() {
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    return now.substring(now.length - 10);
  }
}