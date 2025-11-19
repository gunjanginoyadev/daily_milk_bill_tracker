import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/daily_repository.dart';
import '../models/daily_entry_model.dart';

final dailyRepositoryProvider = Provider<DailyRepository>((ref) => DailyRepository());

final dailyEntriesProvider = FutureProvider.family<List<DailyEntryModel>, String>((ref, monthId) async {
  final repo = ref.watch(dailyRepositoryProvider);
  return repo.fetchEntriesForMonth(monthId);
});

