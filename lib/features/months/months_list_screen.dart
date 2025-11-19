import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/providers/month_provider.dart';
import '../../core/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MonthListScreen extends ConsumerWidget {
  const MonthListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const Center(child: Text('Not logged in'));

    final monthsAsync = ref.watch(monthsListProvider(user.id));

    return AppScaffold(
      title: 'Months',
      child: monthsAsync.when(
        data: (months) {
          return Column(
            children: [
              ElevatedButton.icon(
                onPressed: () => context.go('/months/add'),
                icon: const Icon(Icons.add),
                label: const Text('Add month'),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: months.length,
                  itemBuilder: (context, idx) {
                    final m = months[idx];
                    final name = DateFormat.MMMM().format(DateTime(m.year, m.month));
                    return ListTile(
                      title: Text('$name, ${m.year}'),
                      subtitle: Text('Total: ₹${m.totalAmount.toStringAsFixed(2)} Remaining: ₹${m.remainingThisMonth.toStringAsFixed(2)}'),
                      onTap: () => context.go('/months/${m.id}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
