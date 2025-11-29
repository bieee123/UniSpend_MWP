import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/services/notification_service.dart';

class SettingsProvider extends ChangeNotifier {
  bool isDarkMode = false;
  bool dailyReminderEnabled = true;
  bool weeklySummaryEnabled = true;
  bool budgetAlertsEnabled = true;
  bool dailyTransactionSummaryEnabled = true;
  bool categoryBudgetWarningsEnabled = true;
  bool incomeExpenseAlertsEnabled = true;
  bool largeTransactionAlertsEnabled = true;
  bool budgetRenewalRemindersEnabled = true;
  bool underSpendingAlertsEnabled = true;
  bool lowBudgetBalanceAlertsEnabled = true;
  bool accountSecurityAlertsEnabled = true;
  bool dataSyncAlertsEnabled = true;
  bool spendingPatternAlertsEnabled = true;
  bool monthlyBudgetComparisonEnabled = true;
  bool billPaymentRemindersEnabled = true;
  bool savingGoalProgressEnabled = true;
  bool emergencyFundAlertsEnabled = true;
  bool dataBackupRemindersEnabled = true;
  bool categoryOptimizationSuggestionsEnabled = true;
  bool financialHealthScoreUpdatesEnabled = true;
  bool holidaySpendingAlertsEnabled = true;
  bool taxSeasonAlertsEnabled = true;
  bool yearEndFinancialReviewEnabled = true;

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
    dailyTransactionSummaryEnabled = prefs.getBool('daily_transaction_summary') ?? true;
    categoryBudgetWarningsEnabled = prefs.getBool('category_budget_warnings') ?? true;
    incomeExpenseAlertsEnabled = prefs.getBool('income_expense_alerts') ?? true;
    largeTransactionAlertsEnabled = prefs.getBool('large_transaction_alerts') ?? true;
    budgetRenewalRemindersEnabled = prefs.getBool('budget_renewal_reminders') ?? true;
    underSpendingAlertsEnabled = prefs.getBool('under_spending_alerts') ?? true;
    lowBudgetBalanceAlertsEnabled = prefs.getBool('low_budget_balance_alerts') ?? true;
    accountSecurityAlertsEnabled = prefs.getBool('account_security_alerts') ?? true;
    dataSyncAlertsEnabled = prefs.getBool('data_sync_alerts') ?? true;
    spendingPatternAlertsEnabled = prefs.getBool('spending_pattern_alerts') ?? true;
    monthlyBudgetComparisonEnabled = prefs.getBool('monthly_budget_comparison') ?? true;
    billPaymentRemindersEnabled = prefs.getBool('bill_payment_reminders') ?? true;
    savingGoalProgressEnabled = prefs.getBool('saving_goal_progress') ?? true;
    emergencyFundAlertsEnabled = prefs.getBool('emergency_fund_alerts') ?? true;
    dataBackupRemindersEnabled = prefs.getBool('data_backup_reminders') ?? true;
    categoryOptimizationSuggestionsEnabled = prefs.getBool('category_optimization_suggestions') ?? true;
    financialHealthScoreUpdatesEnabled = prefs.getBool('financial_health_score_updates') ?? true;
    holidaySpendingAlertsEnabled = prefs.getBool('holiday_spending_alerts') ?? true;
    taxSeasonAlertsEnabled = prefs.getBool('tax_season_alerts') ?? true;
    yearEndFinancialReviewEnabled = prefs.getBool('year_end_financial_review') ?? true;
    notifyListeners();
  }

  // Save a single boolean setting
  Future<void> _saveSetting(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> toggleTheme() async {
    isDarkMode = !isDarkMode;
    await _saveSetting('dark_mode', isDarkMode);
    notifyListeners();
  }

  Future<void> toggleDailyReminder() async {
    dailyReminderEnabled = !dailyReminderEnabled;
    await _saveSetting('daily_reminder', dailyReminderEnabled);

    if (dailyReminderEnabled) {
      await _notificationService.scheduleDailyReminder();
    } else {
      // Only cancel daily reminder (ID 1), not all notifications
      await _notificationService.cancelNotificationById(1);
    }

    notifyListeners();
  }

  Future<void> toggleWeeklySummary() async {
    weeklySummaryEnabled = !weeklySummaryEnabled;
    await _saveSetting('weekly_summary', weeklySummaryEnabled);

    if (weeklySummaryEnabled) {
      await _notificationService.scheduleWeeklySummary();
    } else {
      // Only cancel weekly summary (ID 2), not all notifications
      await _notificationService.cancelNotificationById(2);
    }

    notifyListeners();
  }

  Future<void> toggleBudgetAlerts() async {
    budgetAlertsEnabled = !budgetAlertsEnabled;
    await _saveSetting('budget_alerts', budgetAlertsEnabled);
    notifyListeners();
  }

  Future<void> toggleDailyTransactionSummary() async {
    dailyTransactionSummaryEnabled = !dailyTransactionSummaryEnabled;
    await _saveSetting('daily_transaction_summary', dailyTransactionSummaryEnabled);
    notifyListeners();
  }

  Future<void> toggleCategoryBudgetWarnings() async {
    categoryBudgetWarningsEnabled = !categoryBudgetWarningsEnabled;
    await _saveSetting('category_budget_warnings', categoryBudgetWarningsEnabled);
    notifyListeners();
  }

  Future<void> toggleIncomeExpenseAlerts() async {
    incomeExpenseAlertsEnabled = !incomeExpenseAlertsEnabled;
    await _saveSetting('income_expense_alerts', incomeExpenseAlertsEnabled);
    notifyListeners();
  }

  Future<void> toggleLargeTransactionAlerts() async {
    largeTransactionAlertsEnabled = !largeTransactionAlertsEnabled;
    await _saveSetting('large_transaction_alerts', largeTransactionAlertsEnabled);
    notifyListeners();
  }

  Future<void> toggleBudgetRenewalReminders() async {
    budgetRenewalRemindersEnabled = !budgetRenewalRemindersEnabled;
    await _saveSetting('budget_renewal_reminders', budgetRenewalRemindersEnabled);
    notifyListeners();
  }

  Future<void> toggleUnderSpendingAlerts() async {
    underSpendingAlertsEnabled = !underSpendingAlertsEnabled;
    await _saveSetting('under_spending_alerts', underSpendingAlertsEnabled);
    notifyListeners();
  }

  Future<void> toggleLowBudgetBalanceAlerts() async {
    lowBudgetBalanceAlertsEnabled = !lowBudgetBalanceAlertsEnabled;
    await _saveSetting('low_budget_balance_alerts', lowBudgetBalanceAlertsEnabled);
    notifyListeners();
  }

  Future<void> toggleAccountSecurityAlerts() async {
    accountSecurityAlertsEnabled = !accountSecurityAlertsEnabled;
    await _saveSetting('account_security_alerts', accountSecurityAlertsEnabled);
    notifyListeners();
  }

  Future<void> toggleSpendingPatternAlerts() async {
    spendingPatternAlertsEnabled = !spendingPatternAlertsEnabled;
    await _saveSetting('spending_pattern_alerts', spendingPatternAlertsEnabled);
    notifyListeners();
  }

  Future<void> toggleDataSyncAlerts() async {
    dataSyncAlertsEnabled = !dataSyncAlertsEnabled;
    await _saveSetting('data_sync_alerts', dataSyncAlertsEnabled);
    notifyListeners();
  }

  Future<void> toggleMonthlyBudgetComparison() async {
    monthlyBudgetComparisonEnabled = !monthlyBudgetComparisonEnabled;
    await _saveSetting('monthly_budget_comparison', monthlyBudgetComparisonEnabled);
    notifyListeners();
  }

  Future<void> toggleBillPaymentReminders() async {
    billPaymentRemindersEnabled = !billPaymentRemindersEnabled;
    await _saveSetting('bill_payment_reminders', billPaymentRemindersEnabled);
    notifyListeners();
  }

  Future<void> toggleSavingGoalProgress() async {
    savingGoalProgressEnabled = !savingGoalProgressEnabled;
    await _saveSetting('saving_goal_progress', savingGoalProgressEnabled);
    notifyListeners();
  }

  Future<void> toggleEmergencyFundAlerts() async {
    emergencyFundAlertsEnabled = !emergencyFundAlertsEnabled;
    await _saveSetting('emergency_fund_alerts', emergencyFundAlertsEnabled);
    notifyListeners();
  }

  Future<void> toggleDataBackupReminders() async {
    dataBackupRemindersEnabled = !dataBackupRemindersEnabled;
    await _saveSetting('data_backup_reminders', dataBackupRemindersEnabled);
    notifyListeners();
  }

  Future<void> toggleCategoryOptimizationSuggestions() async {
    categoryOptimizationSuggestionsEnabled = !categoryOptimizationSuggestionsEnabled;
    await _saveSetting('category_optimization_suggestions', categoryOptimizationSuggestionsEnabled);
    notifyListeners();
  }

  Future<void> toggleFinancialHealthScoreUpdates() async {
    financialHealthScoreUpdatesEnabled = !financialHealthScoreUpdatesEnabled;
    await _saveSetting('financial_health_score_updates', financialHealthScoreUpdatesEnabled);
    notifyListeners();
  }

  Future<void> toggleHolidaySpendingAlerts() async {
    holidaySpendingAlertsEnabled = !holidaySpendingAlertsEnabled;
    await _saveSetting('holiday_spending_alerts', holidaySpendingAlertsEnabled);
    notifyListeners();
  }

  Future<void> toggleTaxSeasonAlerts() async {
    taxSeasonAlertsEnabled = !taxSeasonAlertsEnabled;
    await _saveSetting('tax_season_alerts', taxSeasonAlertsEnabled);
    notifyListeners();
  }

  Future<void> toggleYearEndFinancialReview() async {
    yearEndFinancialReviewEnabled = !yearEndFinancialReviewEnabled;
    await _saveSetting('year_end_financial_review', yearEndFinancialReviewEnabled);
    notifyListeners();
  }

  // Getter for notification service to be used in UI
  NotificationService get notificationService => _notificationService;
}
