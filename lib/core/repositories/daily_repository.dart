import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/daily_entry_model.dart';

class DailyRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<DailyEntryModel>> fetchEntriesForMonth(String monthId) async {
    final List<dynamic> data = await _client
        .from('daily_entries')
        .select()
        .eq('month_id', monthId)
        .order('date', ascending: true);

    return data
        .map((item) => DailyEntryModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<DailyEntryModel> createEntry(Map<String, dynamic> payload) async {
    final List<dynamic> res = await _client
        .from('daily_entries')
        .insert(payload)
        .select();

    // Supabase always returns a List even for single insert
    return DailyEntryModel.fromMap(res.first as Map<String, dynamic>);
  }

  Future<DailyEntryModel> updateEntry(String id, Map<String, dynamic> payload) async {
    final List<dynamic> res = await _client
        .from('daily_entries')
        .update(payload)
        .eq('id', id)
        .select();

    return DailyEntryModel.fromMap(res.first as Map<String, dynamic>);
  }

  Future<void> deleteEntry(String id) async {
    await _client
        .from('daily_entries')
        .delete()
        .eq('id', id);
  }

  Future<DailyEntryModel?> fetchEntryByDate(String dateKey) async {
  try {
    final res = await _client
        .from('daily_entries')
        .select()
        .eq('date', dateKey)
        .limit(1)
        .maybeSingle();

    if (res == null) return null;

    return DailyEntryModel.fromMap(res);
  } catch (e) {
    print("Error fetching entry for $dateKey: $e");
    return null;
  }
}


}
