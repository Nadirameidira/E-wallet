class Transaction {
  final String title;
  final int amount;
  final int adminFee;
  final String type;
  final String date;

  Transaction({
    required this.title,
    required this.amount,
    required this.adminFee,
    required this.type,
    required this.date,
  });

  int get total => amount + adminFee;

  Map<String, dynamic> toJson() => {
        'title': title,
        'amount': amount,
        'adminFee': adminFee,
        'type': type,
        'date': date,
      };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        title: json['title'] as String,
        amount: json['amount'] as int,
        adminFee: json['adminFee'] as int,
        type: json['type'] as String,
        date: json['date'] as String,
      );
}