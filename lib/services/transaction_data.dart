import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';

//Riwayat transaksi user disimpan per-userId biar tidak ketukar antar akun.
class TransactionService {
  static const _keyPrefix = 'history_';

  // Ambil semua transaksi milik 1 user (terbaru muncul di paling atas)
  static Future<List<Transaction>> getHistory(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('$_keyPrefix$userId');
    if (data == null) return [];

    final decoded = jsonDecode(data) as List;
    return decoded
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Simpan transaksi baru ke riwayat user
  static Future<void> addTransaction(
    String userId,
    Transaction trx,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getHistory(userId);
    existing.insert(0, trx); 

    final encoded = jsonEncode(existing.map((e) => e.toJson()).toList());
    await prefs.setString('$_keyPrefix$userId', encoded);
  }
}