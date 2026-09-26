import 'package:shared_preferences/shared_preferences.dart';

/// Ngurusin saldo user: nyimpen, nambah (top up), sama ngurangin (transfer/bayar).
/// Disimpen pake SharedPreferences biar ke-persist walau app ditutup.
class BalanceService {
  static const _keyBalance = 'user_balance';

  // Saldo awal buat user baru / pertama kali buka app.
  static const int _defaultBalance = 250000;

  static Future<int> getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_keyBalance)) {
      await prefs.setInt(_keyBalance, _defaultBalance);
      return _defaultBalance;
    }
    return prefs.getInt(_keyBalance) ?? _defaultBalance;
  }

  static Future<int> addBalance(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getBalance();
    final updated = current + amount;
    await prefs.setInt(_keyBalance, updated);
    return updated;
  }

  static Future<int> deductBalance(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getBalance();
    final updated = current - amount < 0 ? 0 : current - amount;
    await prefs.setInt(_keyBalance, updated);
    return updated;
  }
}
