import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milk_tracker/core/providers/month_provider.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/providers/daily_provider.dart';
import '../../core/repositories/month_repository.dart';
import '../../core/models/month_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MonthDetailScreen extends ConsumerWidget {
  final String monthId;
  const MonthDetailScreen({super.key, required this.monthId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyAsync = ref.watch(dailyEntriesProvider(monthId));
    // fetch month detail
    final monthRepo = ref.read(monthRepositoryProvider);

    return AppScaffold(
      title: 'Month Detail',
      child: FutureBuilder<MonthModel?>(
        future: _fetchMonth(monthRepo, monthId),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done)
            return const Center(child: CircularProgressIndicator());
          final month = snap.data;
          if (month == null)
            return const Center(child: Text('Month not found'));

          return Column(
            children: [
              Card(
                child: ListTile(
                  title: Text(
                    'Price: ₹${month.pricePerLiter} | Total liters: ${month.totalLiters}',
                  ),
                  subtitle: Text(
                    'Total: ₹${month.totalAmount.toStringAsFixed(2)} | Remaining: ₹${month.remainingThisMonth.toStringAsFixed(2)} | Jama: ₹${month.jamaThisMonth.toStringAsFixed(2)}',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.go('/months/$monthId/daily'),
                child: const Text('Add / Manage Daily entries'),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: dailyAsync.when(
                  data: (entries) {
                    if (entries.isEmpty)
                      return const Center(child: Text('No entries.'));
                    return ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, idx) {
                        final e = entries[idx];
                        return ListTile(
                          title: Text(DateFormat.yMMMEd().format(e.date)),
                          subtitle: Text(
                            '${e.liters} L — ₹${e.calculatedAmount.toStringAsFixed(2)}',
                          ),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, s) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<MonthModel?> _fetchMonth(MonthRepository repo, String id) async {
    final res = await repo.fetchMonthsForUser(repo.currentUser!.id);
    return res.firstWhereOrNull((m) => m.id == id);
  }
}
