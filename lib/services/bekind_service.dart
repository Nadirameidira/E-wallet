import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class BeKindModel {
  final String code;
  final String creatorName;
  final int totalAmount;
  int remainingAmount;
  final int totalSlots;
  int remainingSlots;
  final String message;
  final DateTime createdAt;

  BeKindModel({
    required this.code,
    required this.creatorName,
    required this.totalAmount,
    required this.remainingAmount,
    required this.totalSlots,
    required this.remainingSlots,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'creatorName': creatorName,
        'totalAmount': totalAmount,
        'remainingAmount': remainingAmount,
        'totalSlots': totalSlots,
        'remainingSlots': remainingSlots,
        'message': message,
        'createdAt': createdAt.toIso8601String(),
      };

  factory BeKindModel.fromJson(Map<String, dynamic> json) => BeKindModel(
        code: json['code'],
        creatorName: json['creatorName'],
        totalAmount: json['totalAmount'],
        remainingAmount: json['remainingAmount'],
        totalSlots: json['totalSlots'],
        remainingSlots: json['remainingSlots'],
        message: json['message'],
        createdAt: DateTime.parse(json['createdAt']),
      );

  bool get isEmpty => remainingSlots <= 0 || remainingAmount <= 0;
}

class BeKindService {
  static const _keyBeKindList = 'bekind_list';

  static String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rand = Random();
    final code =
        List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join();
    return 'KIND-$code';
  }

  static Future<BeKindModel> create({
    required String creatorName,
    required int amount,
    required int slots,
    required String message,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await _getAll();

    final bekind = BeKindModel(
      code: _generateCode(),
      creatorName: creatorName,
      totalAmount: amount,
      remainingAmount: amount,
      totalSlots: slots,
      remainingSlots: slots,
      message: message,
      createdAt: DateTime.now(),
    );

    list.add(bekind);
    await prefs.setString(
      _keyBeKindList,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
    return bekind;
  }

  static Future<List<BeKindModel>> _getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyBeKindList);
    if (raw == null) return [];
    final List data = jsonDecode(raw);
    return data.map((e) => BeKindModel.fromJson(e)).toList();
  }

  static Future<BeKindModel?> claim(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await _getAll();
    final idx = list.indexWhere(
      (e) => e.code.toUpperCase() == code.toUpperCase(),
    );
    if (idx == -1) return null;

    final bekind = list[idx];
    if (bekind.isEmpty) return null;

    final perSlot = bekind.totalAmount ~/ bekind.totalSlots;
    bekind.remainingAmount -= perSlot;
    bekind.remainingSlots -= 1;

    list[idx] = bekind;
    await prefs.setString(
      _keyBeKindList,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );

    return BeKindModel(
      code: bekind.code,
      creatorName: bekind.creatorName,
      totalAmount: bekind.totalAmount,
      remainingAmount: bekind.remainingAmount,
      totalSlots: bekind.totalSlots,
      remainingSlots: bekind.remainingSlots,
      message: bekind.message,
      createdAt: bekind.createdAt,
    );
  }
}