import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

/// Thin wrapper around flutter_local_notifications, scoped to Cyster's
/// menstrual-phase alerts. Kept as a single, simple service rather than a
/// Riverpod provider since it largely wraps a singleton plugin instance and
/// has no reactive state of its own — phase-change *decisions* live in
/// `phaseNotificationSchedulerProvider` instead, which does use Riverpod.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const String _channelId = 'cyster_phase_channel';
  static const String _channelName = 'Cycle Phase Alerts';
  static const String _channelDescription = 'Notifies you when a new menstrual cycle phase is estimated to begin.';

  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));
    } catch (_) {
      // Fall back silently to UTC if the device timezone name isn't in the
      // tz database (this happens on some platforms); notifications will
      // still fire, just anchored to UTC offsets instead of named zones.
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _plugin.initialize(initSettings);

    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final iosImpl = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    bool granted = true;
    if (androidImpl != null) {
      final result = await androidImpl.requestNotificationsPermission();
      granted = granted && (result ?? true);
    }
    if (iosImpl != null) {
      final result = await iosImpl.requestPermissions(alert: true, badge: true, sound: true);
      granted = granted && (result ?? true);
    }
    return granted;
  }

  Future<void> showNow({required int id, required String title, required String body}) async {
    await init();
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _plugin.show(id, title, body, details);
  }

  Future<void> scheduleAt({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await init();
    if (scheduledDate.isBefore(DateTime.now())) {
      // Don't schedule things in the past; just skip silently.
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    try {
      final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to schedule notification: $e');
      }
    }
  }

  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
