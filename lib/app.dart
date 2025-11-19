import 'package:flutter/material.dart';
import 'package:milk_tracker/routes.dart';

class DailyMilkApp extends StatelessWidget {
  const DailyMilkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = createRouter();
    return MaterialApp.router(
      title: 'Daily Milk Tracker',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      routerConfig: router,
    );
  }
}
