import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/cycle/cycle_provider.dart';
import '../cycle_phase/cycle_phase_estimator.dart';
import 'notification_service.dart';

const String _notificationsEnabledKey = 'cyster_phase_notifications_enabled';

/// Stable notification IDs per phase so re-scheduling naturally replaces
/// (rather than duplicates) a previous alert for the same phase.
int _notificationIdFor(CyclePhase phase) {
  switch (phase) {
    case CyclePhase.menstrual:
      return 9001;
    case CyclePhase.follicular:
      return 9002;
    case CyclePhase.ovulation:
      return 9003;
    case CyclePhase.luteal:
      return 9004;
  }
}

String _titleFor(CyclePhase phase) {
  switch (phase) {
    case CyclePhase.menstrual:
      return 'Your period may be starting';
    case CyclePhase.follicular:
      return 'Entering your follicular phase';
    case CyclePhase.ovulation:
      return "You're entering your fertile window";
    case CyclePhase.luteal:
      return 'Entering your luteal phase';
  }
}

String _bodyFor(CyclePhase phase) {
  switch (phase) {
    case CyclePhase.menstrual:
      return 'Based on your logged cycles, your period is estimated to begin around today.';
    case CyclePhase.follicular:
      return 'Energy often starts climbing through this phase — a good window for higher-intensity workouts.';
    case CyclePhase.ovulation:
      return 'This is your estimated peak fertility window. A good time to log symptoms if you are trying to conceive (or avoid, if not).';
    case CyclePhase.luteal:
      return 'PMS-type symptoms can show up here — bloating, cravings, and mood shifts are common. Be gentle with yourself.';
  }
}

/// Whether the user has phase notifications turned on, persisted locally.
class PhaseNotificationSettingsNotifier extends StateNotifier<bool> {
  PhaseNotificationSettingsNotifier() : super(true) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
    if (!enabled) {
      await NotificationService().cancelAll();
    }
  }
}

final phaseNotificationSettingsProvider =
    StateNotifierProvider<PhaseNotificationSettingsNotifier, bool>(
  (ref) => PhaseNotificationSettingsNotifier(),
);

/// Reacts to changes in cycle history / predictions and (re)schedules local
/// notifications for each upcoming phase start in the current estimated
/// cycle. This provider has no meaningful "value" of its own — it's kept
/// alive (via `ref.watch` from a long-lived widget, see main.dart) purely
/// for its side effect of keeping schedules in sync with the latest data.
final phaseNotificationSchedulerProvider = Provider<void>((ref) {
  final notificationsEnabled = ref.watch(phaseNotificationSettingsProvider);
  final cycleListAsync = ref.watch(cycleListProvider);

  if (!notificationsEnabled) return;

  cycleListAsync.whenData((cycles) async {
    if (cycles.length < 3) return; // Mirrors the predictor's own minimum threshold.

    final windows = CyclePhaseEstimator.estimateCurrentCyclePhases(cycles);
    if (windows == null) return;

    final service = NotificationService();
    await service.init();

    for (final window in windows) {
      // Fire at 9:00 AM local time on the estimated start day of each phase.
      final fireDate = DateTime(window.start.year, window.start.month, window.start.day, 9, 0);
      await service.scheduleAt(
        id: _notificationIdFor(window.phase),
        title: _titleFor(window.phase),
        body: _bodyFor(window.phase),
        scheduledDate: fireDate,
      );
    }
  });
});
