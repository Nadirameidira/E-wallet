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
}