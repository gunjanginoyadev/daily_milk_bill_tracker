import 'package:go_router/go_router.dart';
import 'package:milk_tracker/features/auth/login_screen.dart';
import 'package:milk_tracker/features/auth/signup_screen.dart';
import 'package:milk_tracker/features/daily/daily_entry_screen.dart';
import 'package:milk_tracker/features/dashboard/dashboard_screen.dart';
import 'package:milk_tracker/features/months/add_edit_month_screen.dart';
import 'package:milk_tracker/features/months/month_detail_screen.dart';
import 'package:milk_tracker/features/months/months_list_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (ctx, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (ctx, state) => const SignUpScreen()),
      GoRoute(path: '/', builder: (ctx, state) => const DashboardScreen()),
      GoRoute(path: '/months', builder: (ctx, state) => const MonthListScreen()),
      GoRoute(path: '/months/add', builder: (ctx, state) => const AddEditMonthScreen()),
      GoRoute(path: '/months/:id', builder: (ctx, state) {
        final id = state.pathParameters['id']!;
        return MonthDetailScreen(monthId: id);
      }),
      GoRoute(path: '/months/:id/daily', builder: (ctx, state) {
        final id = state.pathParameters['id']!;
        return DailyEntryScreen(monthId: id);
      }),
    ],
  );
}
