import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/month_model.dart';

class MonthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  Future<List<MonthModel>> fetchMonthsForUser(String userId) async {
    final List<dynamic> data = await _client
        .from('months')
        .select()
        .eq('user_id', userId)
        .order('year', ascending: false)
        .order('month', ascending: false);

    return data
        .map((m) => MonthModel.fromMap(m as Map<String, dynamic>))
        .toList();
  }

  Future<MonthModel> createMonth(Map<String, dynamic> payload) async {
    final List<dynamic> res = await _client
        .from('months')
        .insert(payload)
        .select();

    return MonthModel.fromMap(res.first as Map<String, dynamic>);
  }

  Future<MonthModel> updateMonth(String id, Map<String, dynamic> payload) async {
    final List<dynamic> res = await _client
        .from('months')
        .update(payload)
        .eq('id', id)
        .select();

    return MonthModel.fromMap(res.first as Map<String, dynamic>);
  }

  Future<void> deleteMonth(String id) async {
    await _client
        .from('months')
        .delete()
        .eq('id', id);
  }

  Future<MonthModel?> getLastMonthForUser(int year, int month, String userId) async {
    // previous month logic
    int prevMonth = month - 1;
    int prevYear = year;

    if (prevMonth == 0) {
      prevMonth = 12;
      prevYear -= 1;
    }

    final List<dynamic> res = await _client
        .from('months')
        .select()
        .eq('user_id', userId)
        .eq('month', prevMonth)
        .eq('year', prevYear)
        .limit(1);

    if (res.isEmpty) return null;

    return MonthModel.fromMap(res.first as Map<String, dynamic>);
  }
}
