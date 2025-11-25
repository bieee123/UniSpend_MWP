import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'uni_spend_channel',
    'UniSpend Notifications',
    description: 'Notifications for UniSpend app',
    importance: Importance.max,
  );

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  // Show daily reminder notification
  Future<void> scheduleDailyReminder() async {
    await _notifications.zonedSchedule(
      1,
      'Daily Reminder',
      'Don\'t forget to record your spending today!',
      _getTomorrowMorning(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Show weekly summary notification
  Future<void> scheduleWeeklySummary() async {
    await _notifications.zonedSchedule(
      2,
      'Weekly Summary',
      'Review your weekly spending and set new goals!',
      _getNextWeek(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Send budget limit notification
  Future<void> sendBudgetLimitNotification(String message) async {
    await _notifications.show(
      3,
      'Budget Alert',
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // Helper methods to calculate notification times
  tz.TZDateTime _getTomorrowMorning() {
    final now = tz.TZDateTime.now(tz.local);
    return tz.TZDateTime(tz.local, now.year, now.month, now.day + 1, 9); // 9 AM
  }

  tz.TZDateTime _getNextWeek() {
    final now = tz.TZDateTime.now(tz.local);
    return tz.TZDateTime(tz.local, now.year, now.month, now.day + 7, 10); // 10 AM
  }

  // Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
