import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/services/notification_service.dart';

class SettingsProvider extends ChangeNotifier {
  bool isDarkMode = false;
  bool dailyReminderEnabled = true;
  bool weeklySummaryEnabled = true;
  bool budgetAlertsEnabled = true;

  final NotificationService _notificationService = NotificationService();

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('dark_mode') ?? false;
    dailyReminderEnabled = prefs.getBool('daily_reminder') ?? true;
    weeklySummaryEnabled = prefs.getBool('weekly_summary') ?? true;
    budgetAlertsEnabled = prefs.getBool('budget_alerts') ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    isDarkMode = !isDarkMode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDarkMode);
    notifyListeners();
  }

  Future<void> toggleDailyReminder() async {
    dailyReminderEnabled = !dailyReminderEnabled;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder', dailyReminderEnabled);

    if (dailyReminderEnabled) {
      await _notificationService.scheduleDailyReminder();
    } else {
      await _notificationService.cancelAllNotifications();
    }

    notifyListeners();
  }

  Future<void> toggleWeeklySummary() async {
    weeklySummaryEnabled = !weeklySummaryEnabled;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('weekly_summary', weeklySummaryEnabled);

    if (weeklySummaryEnabled) {
      await _notificationService.scheduleWeeklySummary();
    } else {
      await _notificationService.cancelAllNotifications();
    }

    notifyListeners();
  }

  Future<void> toggleBudgetAlerts() async {
    budgetAlertsEnabled = !budgetAlertsEnabled;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('budget_alerts', budgetAlertsEnabled);
    notifyListeners();
  }
}
