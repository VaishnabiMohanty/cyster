import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/app_database.dart';
import 'core/database/database_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/notifications/phase_notification_scheduler.dart';
import 'core/notifications/phase_banner.dart';
import 'features/cycle/cycle_screen.dart';
import 'features/symptoms/symptom_screen.dart';
import 'features/journal/journal_screen.dart';
import 'features/reports/report_screen.dart';
import 'features/more/more_hub_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await initDatabase();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Cyster PCOS Companion',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    _CycleHomeWithBanner(),
    SymptomScreen(),
    JournalScreen(),
    ReportScreen(),
    MoreHubScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Keep the phase notification scheduler alive for the lifetime of the
    // app shell so it re-syncs schedules whenever cycle data changes,
    // regardless of which tab the user is currently viewing.
    ref.watch(phaseNotificationSchedulerProvider);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.calendar_today_outlined), selectedIcon: Icon(Icons.calendar_today), label: 'Cycles'),
          NavigationDestination(icon: Icon(Icons.health_and_safety_outlined), selectedIcon: Icon(Icons.health_and_safety), label: 'Symptoms'),
          NavigationDestination(icon: Icon(Icons.book_outlined), selectedIcon: Icon(Icons.book), label: 'Journal'),
          NavigationDestination(icon: Icon(Icons.analytics_outlined), selectedIcon: Icon(Icons.analytics), label: 'Report'),
          NavigationDestination(icon: Icon(Icons.apps_outlined), selectedIcon: Icon(Icons.apps), label: 'More'),
        ],
      ),
    );
  }
}

/// Wraps the existing CycleScreen with the in-app phase banner on top,
/// without modifying CycleScreen's own internals.
class _CycleHomeWithBanner extends StatelessWidget {
  const _CycleHomeWithBanner();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CycleScreen(),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: PhaseBanner(),
          ),
        ),
      ],
    );
  }
}
