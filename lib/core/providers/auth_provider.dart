import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<AuthState>((ref) {
  final service = ref.watch(authServiceProvider);
  return service.authStateChanges();
});

final currentUserProvider = Provider<User?>((ref) {
  final service = ref.watch(authServiceProvider);
  return service.currentUser;
});
