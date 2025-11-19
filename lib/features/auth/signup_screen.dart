import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});
  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
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

    final res = await auth.signUp(_email.trim(), _password);

    // Sign-up success happens when the User object exists.
    if (res.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup failed')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Check your email for confirmation link')),
    );

    context.go('/login');
  } on AuthException catch (e) {
    // Supabase authentication errors (email exists, invalid password etc.)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message)),
    );
  } catch (e) {
    // Other unexpected errors
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
                const Text('Create Account', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                          child: _loading ? const CircularProgressIndicator() : const Text('Sign up'),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text('Already have account? Login'),
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
