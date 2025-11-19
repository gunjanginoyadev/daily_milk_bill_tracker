import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;

  const AppScaffold({super.key, required this.child, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(12), child: child)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
