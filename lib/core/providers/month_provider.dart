import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/month_repository.dart';
import '../models/month_model.dart';

final monthRepositoryProvider = Provider<MonthRepository>((ref) => MonthRepository());

final monthsListProvider = FutureProvider.family<List<MonthModel>, String>((ref, userId) async {
  final repo = ref.watch(monthRepositoryProvider);
  return repo.fetchMonthsForUser(userId);
});
