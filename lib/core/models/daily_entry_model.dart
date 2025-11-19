class DailyEntryModel {
  final String id;
  final String monthId;
  final DateTime date;
  final double liters;
  final double calculatedAmount;
  final DateTime createdAt;

  DailyEntryModel({
    required this.id,
    required this.monthId,
    required this.date,
    required this.liters,
    required this.calculatedAmount,
    required this.createdAt,
  });

  factory DailyEntryModel.fromMap(Map<String, dynamic> m) {
    return DailyEntryModel(
      id: m['id'] as String,
      monthId: m['month_id'] as String,
      date: DateTime.parse(m['date'] as String),
      liters: (m['liters'] ?? 0).toDouble(),
      calculatedAmount: (m['calculated_amount'] ?? 0).toDouble(),
      createdAt: DateTime.parse(m['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'month_id': monthId,
        'date': date.toIso8601String().split('T').first,
        'liters': liters,
        'calculated_amount': calculatedAmount,
      };
}
