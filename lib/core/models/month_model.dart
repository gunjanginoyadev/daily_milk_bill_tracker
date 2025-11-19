class MonthModel {
  final String id;
  final String userId;
  final int month;
  final int year;
  final double pricePerLiter;
  final double totalLiters;
  final double totalAmount;
  final double remainingFromLast;
  final double jamaFromLast;
  final double userPaid;
  final double remainingThisMonth;
  final double jamaThisMonth;
  final DateTime createdAt;

  MonthModel({
    required this.id,
    required this.userId,
    required this.month,
    required this.year,
    required this.pricePerLiter,
    required this.totalLiters,
    required this.totalAmount,
    required this.remainingFromLast,
    required this.jamaFromLast,
    required this.userPaid,
    required this.remainingThisMonth,
    required this.jamaThisMonth,
    required this.createdAt,
  });

  factory MonthModel.fromMap(Map<String, dynamic> m) {
    return MonthModel(
      id: m['id'] as String,
      userId: m['user_id'] as String,
      month: (m['month'] as num).toInt(),
      year: (m['year'] as num).toInt(),
      pricePerLiter: (m['price_per_liter'] as num).toDouble(),
      totalLiters: (m['total_liters'] ?? 0).toDouble(),
      totalAmount: (m['total_amount'] ?? 0).toDouble(),
      remainingFromLast: (m['remaining_from_last'] ?? 0).toDouble(),
      jamaFromLast: (m['jama_from_last'] ?? 0).toDouble(),
      userPaid: (m['user_paid'] ?? 0).toDouble(),
      remainingThisMonth: (m['remaining_this_month'] ?? 0).toDouble(),
      jamaThisMonth: (m['jama_this_month'] ?? 0).toDouble(),
      createdAt: DateTime.parse(m['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'month': month,
      'year': year,
      'price_per_liter': pricePerLiter,
      'total_liters': totalLiters,
      'total_amount': totalAmount,
      'remaining_from_last': remainingFromLast,
      'jama_from_last': jamaFromLast,
      'user_paid': userPaid,
      'remaining_this_month': remainingThisMonth,
      'jama_this_month': jamaThisMonth,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
