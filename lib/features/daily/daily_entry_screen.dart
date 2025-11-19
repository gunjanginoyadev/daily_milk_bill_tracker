import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milk_tracker/core/providers/month_provider.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/providers/daily_provider.dart';
import 'package:intl/intl.dart';

class DailyEntryScreen extends ConsumerStatefulWidget {
  final String monthId;
  const DailyEntryScreen({super.key, required this.monthId});

  @override
  ConsumerState<DailyEntryScreen> createState() => _DailyEntryScreenState();
}

class _DailyEntryScreenState extends ConsumerState<DailyEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime selected = DateTime.now();
  double liters = 0;
  bool loading = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => loading = true);
    try {
      final monthRepo = ref.read(monthRepositoryProvider);
      final dailyRepo = ref.read(dailyRepositoryProvider);

      // fetch month to know price
      final userId = monthRepo.currentUser!.id;

      final months = await monthRepo.fetchMonthsForUser(userId);
      final month = months.firstWhere((m) => m.id == widget.monthId);

      final amount = (liters * month.pricePerLiter);
      final payload = {
        'month_id': widget.monthId,
        'date': selected.toIso8601String().split('T').first,
        'liters': liters,
        'calculated_amount': amount,
      };

      await dailyRepo.createEntry(payload);

      // After adding entry, update totals on month
      final allEntries = await dailyRepo.fetchEntriesForMonth(widget.monthId);
      final totalLiters = allEntries.fold<double>(0, (p, e) => p + e.liters);
      final totalAmount = totalLiters * month.pricePerLiter;
      // grandTotal = totalAmount + remainingFromLast - jamaFromLast
      double grandTotal =
          totalAmount + month.remainingFromLast - month.jamaFromLast;
      double remainingThisMonth = 0;
      double jamaThisMonth = 0;
      final paid = month.userPaid;
      final afterPaid = grandTotal - paid;
      if (afterPaid > 0)
        remainingThisMonth = afterPaid;
      else
        jamaThisMonth = -afterPaid;

      await monthRepo.updateMonth(month.id, {
        'total_liters': totalLiters,
        'total_amount': totalAmount,
        'remaining_this_month': remainingThisMonth,
        'jama_this_month': jamaThisMonth,
      });

      // refresh provider
      final _ = ref.refresh(dailyEntriesProvider(widget.monthId));

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Entry saved')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(dailyEntriesProvider(widget.monthId));
    return AppScaffold(
      title: 'Daily Entries',
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Date: ${DateFormat.yMMMd().format(selected)}',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: selected,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (d != null) setState(() => selected = d);
                          },
                          child: const Text('Change'),
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Liters (0 allowed)',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (s) => (double.tryParse(s ?? '') ?? -1) >= 0
                          ? null
                          : 'Enter liters >= 0',
                      onSaved: (s) => liters = double.tryParse(s ?? '0') ?? 0,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: loading ? null : _save,
                      child: loading
                          ? const CircularProgressIndicator()
                          : const Text('Save entry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: entriesAsync.when(
              data: (entries) {
                if (entries.isEmpty)
                  return const Center(child: Text('No entries yet.'));
                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, idx) {
                    final e = entries[idx];
                    return ListTile(
                      title: Text(DateFormat.yMMMd().format(e.date)),
                      subtitle: Text(
                        '${e.liters} L — ₹${e.calculatedAmount.toStringAsFixed(2)}',
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
