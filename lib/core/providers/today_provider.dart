import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milk_tracker/core/providers/daily_provider.dart';
import 'package:milk_tracker/core/providers/month_provider.dart';

final currentMonthProvider = FutureProvider((ref) async {
  final repo = ref.read(monthRepositoryProvider);
  final user = repo.currentUser!;
  final months = await repo.fetchMonthsForUser(user.id);

  if (months.isEmpty) return null;

  months.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // latest month
  return months.first;
});

final todayEntryProvider = FutureProvider.family((ref, String dateKey) async {
  final repo = ref.read(dailyRepositoryProvider);
  return await repo.fetchEntryByDate(dateKey);
});
