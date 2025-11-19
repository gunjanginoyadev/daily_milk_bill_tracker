import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatefulWidget {
  final Widget child;
  const DashboardScreen({super.key, required this.child});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  final List<String> routes = [
    '/months',
    '/daily',
    '/today'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => context.go('/home'),
          child: Row(
            children: [
              Image.asset(
                'assets/logo.png',
                height: 34,
              ),
              const SizedBox(width: 12),
              const Text(
                "Milk Tracker",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),

      body: Row(
        children: [
          // LEFT NAVIGATION RAIL
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) {
              setState(() => selectedIndex = i);
              context.go(routes[i]);
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.calendar_month_outlined),
                label: Text("Months"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list_alt_outlined),
                label: Text("Daily"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.today_outlined),
                label: Text("Today"),
              ),
            ],
          ),

          // MAIN CONTENT AREA
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
