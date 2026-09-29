class BeKindModel {
  final String code;
  final String creatorName;
  final int totalAmount;
  final int remainingAmount;
  final int totalSlots;
  final int remainingSlots;
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