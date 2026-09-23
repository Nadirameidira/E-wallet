import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const _keyUser = 'registered_user';
  static const _keyLogin = 'is_logged_in';

  static Future<bool> register(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_keyUser);
    if (existing != null) {
      final old = UserModel.fromJson(jsonDecode(existing));
      if (old.userId == user.userId) return false;
    }
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
    return true;
  }

  static Future<UserModel?> loginStep1(String userId, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyUser);
    if (data == null) return null;

    final user = UserModel.fromJson(jsonDecode(data));
    if (user.userId == userId && user.password == password) {
      return user;
    }
    return null;
  }

  static Future<bool> verifyPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyUser);
    if (data == null) return false;

    final user = UserModel.fromJson(jsonDecode(data));
    if (user.pin == pin) {
      await prefs.setBool(_keyLogin, true);
      return true;
    }
    return false;
  }

  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyUser);
    if (data == null) return null;
    return UserModel.fromJson(jsonDecode(data));
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLogin) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLogin, false);
  }
}