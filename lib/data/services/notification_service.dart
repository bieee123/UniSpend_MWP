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

  // 1. Daily Transaction Summary
  Future<void> sendDailyTransactionSummary(double totalSpent, String percentage) async {
    await _notifications.show(
      4,
      'Daily Financial Summary',
      'Today you spent Rp ${totalSpent.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}, which is $percentage of your daily average budget',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 2. Category-Specific Budget Warnings
  Future<void> sendCategoryBudgetWarning(String category, String percentage) async {
    await _notifications.show(
      5,
      'Category Budget Alert',
      'You\'ve spent $percentage of your $category budget for this period',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 3. Income vs Expense Ratio Alert
  Future<void> sendIncomeExpenseRatioAlert(double expensePercentage) async {
    await _notifications.show(
      6,
      'Financial Balance Alert',
      'Your expenses are ${expensePercentage.toStringAsFixed(0)}% of your income. Consider adjusting your spending',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 4. Large Transaction Alert
  Future<void> sendLargeTransactionAlert(double amount, String threshold) async {
    await _notifications.show(
      7,
      'Large Transaction Alert',
      'Large transaction of Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} was recorded. Check if this was intentional',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 5. Budget Renewal Reminder
  Future<void> sendBudgetRenewalReminder(String category) async {
    await _notifications.show(
      8,
      'Budget Renewal Needed',
      'Your $category budget expires tomorrow. Renew or adjust your limit',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 6. Under-Spending Alert
  Future<void> sendUnderSpendingAlert(String category, String percentage) async {
    await _notifications.show(
      9,
      'Under-Spending Alert',
      'You\'ve used only $percentage of your $category budget. Consider reallocating funds',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 7. Budget Category Low Balance
  Future<void> sendBudgetLowBalanceAlert(String category, double remainingAmount) async {
    await _notifications.show(
      10,
      'Low Budget Balance',
      'Low balance in $category budget. Only Rp ${remainingAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} left',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 8. Login Activity Alert
  Future<void> sendLoginActivityAlert(String location) async {
    await _notifications.show(
      11,
      'Account Security Alert',
      'New login detected from $location. Verify this is you',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 9. Data Synchronization Status
  Future<void> sendDataSyncAlert() async {
    await _notifications.show(
      12,
      'Data Synchronized',
      'Your financial data has been synchronized across all devices',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 10. Spending Pattern Alert
  Future<void> sendSpendingPatternAlert(double percentageChange) async {
    await _notifications.show(
      13,
      'Spending Pattern Alert',
      'Your spending this week is ${percentageChange.toStringAsFixed(0)}% higher than usual. Review your expenses',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 11. Monthly Budget Comparison
  Future<void> sendMonthlyBudgetComparison(double amount, double percentage) async {
    await _notifications.show(
      14,
      'Monthly Budget Summary',
      'This month you spent Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}, which is ${percentage.toStringAsFixed(0)}% more/less than last month',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 12. Bill Payment Reminder
  Future<void> sendBillPaymentReminder(String billName, int daysLeft) async {
    await _notifications.show(
      15,
      'Bill Payment Reminder',
      'Your $billName payment is due in $daysLeft days',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 13. Saving Goal Progress
  Future<void> sendSavingGoalProgress(double percentage, double goalAmount) async {
    await _notifications.show(
      16,
      'Saving Goal Progress',
      'You\'re ${percentage.toStringAsFixed(0)}% toward your saving goal of Rp ${goalAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}. Keep going!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 14. Emergency Fund Low Alert
  Future<void> sendEmergencyFundLowAlert() async {
    await _notifications.show(
      17,
      'Emergency Fund Alert',
      'Your emergency fund is low. Consider adding more funds',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 15. Data Backup Reminder
  Future<void> sendDataBackupReminder() async {
    await _notifications.show(
      18,
      'Data Backup Reminder',
      'It\'s time to backup your financial data. Export your data to stay safe',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 16. Category Optimization Suggestion
  Future<void> sendCategoryOptimizationSuggestion(String category) async {
    await _notifications.show(
      19,
      'Budget Optimization',
      'You\'re spending more on $category. Consider creating a specific budget for it',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 17. Financial Health Score Update
  Future<void> sendFinancialHealthScore(int score, String suggestion) async {
    await _notifications.show(
      20,
      'Financial Health Score',
      'Your financial health score is $score/10. $suggestion',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 18. Holiday Spending Alert
  Future<void> sendHolidaySpendingAlert() async {
    await _notifications.show(
      21,
      'Holiday Spending Alert',
      'Holiday season spending is starting. Remember to stick to your budget',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 19. Tax Season Preparation
  Future<void> sendTaxSeasonPreparation() async {
    await _notifications.show(
      22,
      'Tax Season Preparation',
      'Tax season is approaching. Review your income and expense records',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }

  // 20. Year-End Financial Review
  Future<void> sendYearEndFinancialReview(double spentAmount, double savedAmount) async {
    await _notifications.show(
      23,
      'Year-End Financial Summary',
      'Year-end financial summary: You spent Rp ${spentAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} and saved Rp ${savedAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} this year',
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

  // Cancel a specific notification by ID
  Future<void> cancelNotificationById(int id) async {
    await _notifications.cancel(id);
  }

  // Test notification functionality
  Future<void> sendTestNotification() async {
    await _notifications.show(
      999, // Test notification ID
      'Test Notification',
      'This is a test notification to verify your notification settings are working properly.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uni_spend_channel',
          'UniSpend Notifications',
          channelDescription: 'Notifications for UniSpend app',
        ),
      ),
    );
  }
}
