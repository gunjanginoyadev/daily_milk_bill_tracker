import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milk_tracker/core/providers/month_provider.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/providers/auth_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';

class AddEditMonthScreen extends ConsumerStatefulWidget {
  const AddEditMonthScreen({super.key});
  @override
  ConsumerState<AddEditMonthScreen> createState() => _AddEditMonthScreenState();
}

class _AddEditMonthScreenState extends ConsumerState<AddEditMonthScreen> {
  final _formKey = GlobalKey<FormState>();
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  double price = 0.0;
  double paid = 0.0;
  bool loading = false;

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => loading = true);
    try {
      final auth = ref.read(currentUserProvider);
      if (auth == null) throw Exception('Not logged in');
      final repo = ref.read(monthRepositoryProvider);

      // Try to auto-fill last month
      final last = await repo.getLastMonthForUser(year, month, auth.id);
      final remainingFromLast = last?.remainingThisMonth ?? 0.0;
      final jamaFromLast = last?.jamaThisMonth ?? 0.0;

      // compute totals initially 0
      final id = const Uuid().v4();
      final payload = {
        'id': id,
        'user_id': auth.id,
        'month': month,
        'year': year,
        'price_per_liter': price,
        'total_liters': 0,
        'total_amount': 0,
        'remaining_from_last': remainingFromLast,
        'jama_from_last': jamaFromLast,
        'user_paid': paid,
        'remaining_this_month': 0,
        'jama_this_month': 0,
      };

      await repo.createMonth(payload);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Month created')));
      context.go('/months');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Add Month',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: month,
                      items: List.generate(12, (i) => i + 1).map((m) => DropdownMenuItem(value: m, child: Text('$m'))).toList(),
                      onChanged: (v) => setState(() => month = v ?? month),
                      decoration: const InputDecoration(labelText: 'Month (1-12)'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      initialValue: year.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Year'),
                      onSaved: (s) => year = int.tryParse(s ?? '') ?? year,
                    ),
                  )
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price per liter'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (s) => (double.tryParse(s ?? '') ?? -1) >= 0 ? null : 'Enter price',
                onSaved: (s) => price = double.tryParse(s ?? '0') ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount paid now (optional)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onSaved: (s) => paid = double.tryParse(s ?? '0') ?? 0,
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: loading ? null : _save, child: loading ? const CircularProgressIndicator() : const Text('Save')),
            ]),
          ),
        ),
      ),
    );
  }
}
