import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient supabase = Supabase.instance.client;

  static Future<void> init() async {
    const supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://ciiqstwwwdwishkrakep.supabase.co');
    const supabaseKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNpaXFzdHd3d2R3aXNoa3Jha2VwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1NjY5NTYsImV4cCI6MjA3OTE0Mjk1Nn0.Z6MH7lLyvVbK8hclhti1YLV_-wK8B7niG15N6ZAK0Ug');

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  }
}
