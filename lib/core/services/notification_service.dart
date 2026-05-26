import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationChannel(
    'emergency_channel',
    'Emergency Alerts',
    description: 'Critical ambulance and emergency notifications',
    importance: Importance.max,
    playSound: true,
  );

  // ── Init ─────────────────────────────────────────────────────────────────
  static Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create the high-importance channel on Android 8+
    await _plugin
        .resolvePlatformSpecificImplementation
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  static void _onNotificationTap(NotificationResponse response) {
    // Hook into your navigation logic here if needed
  }

  // ── Show emergency alert ─────────────────────────────────────────────────
  static Future<void> showEmergencyAlert({
    required String title,
    required String body,
    int id = 0,
  }) async {
    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFFD32F2F),
          ticker: 'Emergency Alert',
        ),
      ),
    );
  }

  // ── Dispatch notification ────────────────────────────────────────────────
  static Future<void> showDispatchNotification(String unitNumber) async {
    await showEmergencyAlert(
      id: 1,
      title: '🚑 Ambulance Dispatched',
      body: 'Unit $unitNumber is on its way. Estimated arrival: ~4 minutes.',
    );
  }

  // ── Arrival notification ─────────────────────────────────────────────────
  static Future<void> showArrivalNotification() async {
    await showEmergencyAlert(
      id: 2,
      title: '✅ Ambulance Arrived',
      body: 'The ambulance has reached your location.',
    );
  }

  // ── Cancel ───────────────────────────────────────────────────────────────
  static Future<void> cancelAll() => _plugin.cancelAll();
}