import 'package:provider/provider.dart';
import '../state/settings_provider.dart';
import 'notification_service.dart';

class NotificationManager {
  final NotificationService _notificationService;
  final SettingsProvider _settingsProvider;

  NotificationManager({
    required NotificationService notificationService,
    required SettingsProvider settingsProvider,
  })  : _notificationService = notificationService,
        _settingsProvider = settingsProvider;

  // Daily Transaction Summary
  Future<void> sendDailyTransactionSummary(double totalSpent, String percentage) async {
    if (_settingsProvider.dailyTransactionSummaryEnabled) {
      await _notificationService.sendDailyTransactionSummary(totalSpent, percentage);
    }
  }

  // Category Budget Warnings
  Future<void> sendCategoryBudgetWarning(String category, String percentage) async {
    if (_settingsProvider.categoryBudgetWarningsEnabled) {
      await _notificationService.sendCategoryBudgetWarning(category, percentage);
    }
  }

  // Income vs Expense Ratio Alert
  Future<void> sendIncomeExpenseRatioAlert(double expensePercentage) async {
    if (_settingsProvider.incomeExpenseAlertsEnabled) {
      await _notificationService.sendIncomeExpenseRatioAlert(expensePercentage);
    }
  }

  // Large Transaction Alert
  Future<void> sendLargeTransactionAlert(double amount, String threshold) async {
    if (_settingsProvider.largeTransactionAlertsEnabled) {
      await _notificationService.sendLargeTransactionAlert(amount, threshold);
    }
  }

  // Budget Renewal Reminder
  Future<void> sendBudgetRenewalReminder(String category) async {
    if (_settingsProvider.budgetRenewalRemindersEnabled) {
      await _notificationService.sendBudgetRenewalReminder(category);
    }
  }

  // Under-Spending Alert
  Future<void> sendUnderSpendingAlert(String category, String percentage) async {
    if (_settingsProvider.underSpendingAlertsEnabled) {
      await _notificationService.sendUnderSpendingAlert(category, percentage);
    }
  }

  // Budget Low Balance Alert
  Future<void> sendBudgetLowBalanceAlert(String category, double remainingAmount) async {
    if (_settingsProvider.lowBudgetBalanceAlertsEnabled) {
      await _notificationService.sendBudgetLowBalanceAlert(category, remainingAmount);
    }
  }

  // Account Security Alert
  Future<void> sendLoginActivityAlert(String location) async {
    if (_settingsProvider.accountSecurityAlertsEnabled) {
      await _notificationService.sendLoginActivityAlert(location);
    }
  }

  // Data Synchronization Alert
  Future<void> sendDataSyncAlert() async {
    if (_settingsProvider.dataSyncAlertsEnabled) {
      await _notificationService.sendDataSyncAlert();
    }
  }

  // Spending Pattern Alert
  Future<void> sendSpendingPatternAlert(double percentageChange) async {
    if (_settingsProvider.spendingPatternAlertsEnabled) {
      await _notificationService.sendSpendingPatternAlert(percentageChange);
    }
  }

  // Monthly Budget Comparison
  Future<void> sendMonthlyBudgetComparison(double amount, double percentage) async {
    if (_settingsProvider.monthlyBudgetComparisonEnabled) {
      await _notificationService.sendMonthlyBudgetComparison(amount, percentage);
    }
  }

  // Bill Payment Reminder
  Future<void> sendBillPaymentReminder(String billName, int daysLeft) async {
    if (_settingsProvider.billPaymentRemindersEnabled) {
      await _notificationService.sendBillPaymentReminder(billName, daysLeft);
    }
  }

  // Saving Goal Progress
  Future<void> sendSavingGoalProgress(double percentage, double goalAmount) async {
    if (_settingsProvider.savingGoalProgressEnabled) {
      await _notificationService.sendSavingGoalProgress(percentage, goalAmount);
    }
  }

  // Emergency Fund Low Alert
  Future<void> sendEmergencyFundLowAlert() async {
    if (_settingsProvider.emergencyFundAlertsEnabled) {
      await _notificationService.sendEmergencyFundLowAlert();
    }
  }

  // Data Backup Reminder
  Future<void> sendDataBackupReminder() async {
    if (_settingsProvider.dataBackupRemindersEnabled) {
      await _notificationService.sendDataBackupReminder();
    }
  }

  // Category Optimization Suggestion
  Future<void> sendCategoryOptimizationSuggestion(String category) async {
    if (_settingsProvider.categoryOptimizationSuggestionsEnabled) {
      await _notificationService.sendCategoryOptimizationSuggestion(category);
    }
  }

  // Financial Health Score Update
  Future<void> sendFinancialHealthScore(int score, String suggestion) async {
    if (_settingsProvider.financialHealthScoreUpdatesEnabled) {
      await _notificationService.sendFinancialHealthScore(score, suggestion);
    }
  }

  // Holiday Spending Alert
  Future<void> sendHolidaySpendingAlert() async {
    if (_settingsProvider.holidaySpendingAlertsEnabled) {
      await _notificationService.sendHolidaySpendingAlert();
    }
  }

  // Tax Season Preparation
  Future<void> sendTaxSeasonPreparation() async {
    if (_settingsProvider.taxSeasonAlertsEnabled) {
      await _notificationService.sendTaxSeasonPreparation();
    }
  }

  // Year-End Financial Review
  Future<void> sendYearEndFinancialReview(double spentAmount, double savedAmount) async {
    if (_settingsProvider.yearEndFinancialReviewEnabled) {
      await _notificationService.sendYearEndFinancialReview(spentAmount, savedAmount);
    }
  }

  // Budget Limit Notification (controlled by budgetAlertsEnabled)
  Future<void> sendBudgetLimitNotification(String message) async {
    if (_settingsProvider.budgetAlertsEnabled) {
      await _notificationService.sendBudgetLimitNotification(message);
    }
  }
}