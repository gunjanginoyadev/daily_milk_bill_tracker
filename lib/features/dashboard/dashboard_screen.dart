import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/month_provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const Center(child: Text('Please login'));

    final monthsAsync = ref.watch(monthsListProvider(user.id));

    return AppScaffold(
      title: 'Dashboard',
      child: monthsAsync.when(
        data: (months) {
          double pending = 0;
          double jama = 0;
          for (var m in months) {
            pending += m.remainingThisMonth;
            jama += m.jamaThisMonth;
          }
          return Column(children: [
            Card(
              child: ListTile(
                title: const Text('Year Totals'),
                subtitle: Text('Pending: ₹${pending.toStringAsFixed(2)}  |  Jama: ₹${jama.toStringAsFixed(2)}'),
                trailing: IconButton(icon: const Icon(Icons.add), onPressed: () => context.go('/months/add')),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: months.length,
                itemBuilder: (context, idx) {
                  final m = months[idx];
                  final name = DateFormat.MMMM().format(DateTime(m.year, m.month));
                  return Card(
                    child: ListTile(
                      title: Text('$name ${m.year}'),
                      subtitle: Text('Liters: ${m.totalLiters} • Total: ₹${m.totalAmount.toStringAsFixed(2)}'),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Remaining: ₹${m.remainingThisMonth.toStringAsFixed(2)}'),
                          const SizedBox(height: 6),
                          Text('Jama: ₹${m.jamaThisMonth.toStringAsFixed(2)}'),
                        ],
                      ),
                      onTap: () => context.go('/months/${m.id}'),
                    ),
                  );
                },
              ),
            ),
          ]);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
