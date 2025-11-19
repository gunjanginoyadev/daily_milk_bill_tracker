import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _loading = false;

  void _submit() async {
  if (!_formKey.currentState!.validate()) return;
  _formKey.currentState!.save();
  setState(() => _loading = true);

  try {
    final auth = ref.read(authServiceProvider);

    // If your AuthService exposes signInWithPassword directly, use that.
    // If it wraps Supabase and uses a different method name (e.g., signIn),
    // keep calling that — the handling below still works.
    final res = await auth.signIn(_email.trim(), _password);

    // Supabase returns an AuthResponse with `session` and `user`.
    // If session is null, authentication failed (bad credentials / no session).
    if (res.session == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
      return;
    }

    // Successful login
    context.go('/');
  } on AuthException catch (e) {
    // Auth specific errors from Supabase/gotrue
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message)),
    );
  } catch (e) {
    // Other errors (network, unexpected)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  } finally {
    setState(() => _loading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 420,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Daily Milk Tracker', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (s) => (s ?? '').contains('@') ? null : 'Enter valid email',
                        onSaved: (s) => _email = s ?? '',
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (s) => (s ?? '').length >= 6 ? null : 'Min 6 chars',
                        onSaved: (s) => _password = s ?? '',
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          child: _loading ? const CircularProgressIndicator() : const Text('Login'),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/signup'),
                        child: const Text('Create account'),
                      )
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
