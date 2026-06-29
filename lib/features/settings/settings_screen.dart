import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/notifications/phase_notification_scheduler.dart';
import '../../core/notifications/notification_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final notificationsEnabled = ref.watch(phaseNotificationSettingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text('Appearance', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
          ),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('Light — Pink & White'),
                  subtitle: const Text('Bright, soft pink palette'),
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  onChanged: (mode) => ref.read(themeModeProvider.notifier).setThemeMode(mode!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark — Deep Pink'),
                  subtitle: const Text('Charcoal-black with a vivid dark-pink hue'),
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  onChanged: (mode) => ref.read(themeModeProvider.notifier).setThemeMode(mode!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('System Default'),
                  subtitle: const Text('Match your device setting'),
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  onChanged: (mode) => ref.read(themeModeProvider.notifier).setThemeMode(mode!),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text('Notifications', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
          ),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Cycle phase alerts'),
                  subtitle: const Text('Get notified when a new menstrual phase is estimated to begin'),
                  value: notificationsEnabled,
                  onChanged: (enabled) async {
                    if (enabled) {
                      await NotificationService().requestPermissions();
                    }
                    await ref.read(phaseNotificationSettingsProvider.notifier).setEnabled(enabled);
                  },
                ),
                if (notificationsEnabled)
                  ListTile(
                    leading: const Icon(Icons.notifications_active_outlined),
                    title: const Text('Send a test notification'),
                    onTap: () => NotificationService().showNow(
                      id: 9999,
                      title: 'Cyster test alert',
                      body: 'This is what your phase alerts will look like.',
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Phase alerts are estimates based on your logged cycle history. They are most accurate after you have logged at least 3 cycles, and may be wider-ranged if your cycles are irregular.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
