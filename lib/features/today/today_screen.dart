import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:milk_tracker/core/providers/today_provider.dart';
import '../../core/providers/daily_provider.dart';

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  double liters = 0;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayKey = DateFormat('yyyy-MM-dd').format(today);

    final selectedMonthAsync = ref.watch(currentMonthProvider);
    final dailyAsync = ref.watch(todayEntryProvider(todayKey));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Entry – ${DateFormat.yMMMd().format(today)}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          selectedMonthAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
            data: (month) {
              if (month == null) {
                return const Text("No active month available");
              }

              return dailyAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text("Error: $e"),
                data: (entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: ListTile(
                          title: Text(
                            entry == null
                                ? "No entry added today"
                                : "${entry.liters} Liters",
                          ),
                          subtitle: entry != null
                              ? Text("₹ ${entry.calculatedAmount.toStringAsFixed(2)}")
                              : const Text(""),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        decoration: const InputDecoration(
                            labelText: "Enter liters for today"),
                        keyboardType: TextInputType.number,
                        onChanged: (v) {
                          liters = double.tryParse(v) ?? 0;
                        },
                      ),

                      const SizedBox(height: 12),

                      ElevatedButton(
                        onPressed: loading
                            ? null
                            : () async {
                                await _saveToday(month.id, month.pricePerLiter);
                              },
                        child: loading
                            ? const CircularProgressIndicator()
                            : const Text("Save Today’s Entry"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _saveToday(String monthId, double price) async {
    setState(() => loading = true);

    try {
      final repo = ref.read(dailyRepositoryProvider);

      final today = DateTime.now();
      final date = DateFormat('yyyy-MM-dd').format(today);

      final amount = liters * price;

      await repo.createEntry({
        'month_id': monthId,
        'date': date,
        'liters': liters,
        'calculated_amount': amount,
      });

      // refresh today's entry
      // ignore: unused_result
      ref.refresh(todayEntryProvider(date));

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Today's entry saved")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
    }
  }
}
