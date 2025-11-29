import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/settings_provider.dart';

class NotificationSettingsPage extends StatelessWidget {
  final bool isInMainLayout;

  const NotificationSettingsPage({super.key, this.isInMainLayout = false});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: isInMainLayout
          ? null
          : AppBar(title: const Text("Notification Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Daily Reminder Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Daily Reminder"),
                  subtitle:
                      const Text("Get reminded to record your spending daily"),
                  value: settingsProvider.dailyReminderEnabled,
                  onChanged: (value) => settingsProvider.toggleDailyReminder(),
                ),
              ),

              const SizedBox(height: 10),

              // Weekly Summary Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Weekly Summary"),
                  subtitle: const Text("Get a summary of your weekly spending"),
                  value: settingsProvider.weeklySummaryEnabled,
                  onChanged: (value) => settingsProvider.toggleWeeklySummary(),
                ),
              ),

              const SizedBox(height: 10),

              // Budget Alerts Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Budget Alerts"),
                  subtitle: const Text(
                      "Get notified when you're close to your budget limit"),
                  value: settingsProvider.budgetAlertsEnabled,
                  onChanged: (value) => settingsProvider.toggleBudgetAlerts(),
                ),
              ),

              const SizedBox(height: 10),

              // Daily Transaction Summary Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Daily Transaction Summary"),
                  subtitle: const Text("Get daily summary of your spending"),
                  value: settingsProvider.dailyTransactionSummaryEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleDailyTransactionSummary(),
                ),
              ),

              const SizedBox(height: 10),

              // Category Budget Warnings Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Category Budget Warnings"),
                  subtitle: const Text(
                      "Get alerts when category budgets are near limit"),
                  value: settingsProvider.categoryBudgetWarningsEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleCategoryBudgetWarnings(),
                ),
              ),

              const SizedBox(height: 10),

              // Income vs Expense Alerts Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Income vs Expense Alerts"),
                  subtitle: const Text(
                      "Get notified about your income-expense ratio"),
                  value: settingsProvider.incomeExpenseAlertsEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleIncomeExpenseAlerts(),
                ),
              ),

              const SizedBox(height: 10),

              // Large Transaction Alerts Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Large Transaction Alerts"),
                  subtitle: const Text("Get warnings for large transactions"),
                  value: settingsProvider.largeTransactionAlertsEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleLargeTransactionAlerts(),
                ),
              ),

              const SizedBox(height: 10),

              // Budget Renewal Reminders Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Budget Renewal Reminders"),
                  subtitle:
                      const Text("Get reminders when budgets are expiring"),
                  value: settingsProvider.budgetRenewalRemindersEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleBudgetRenewalReminders(),
                ),
              ),

              const SizedBox(height: 10),

              // Under-Spending Alerts Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Under-Spending Alerts"),
                  subtitle:
                      const Text("Get alerts when budgets are underutilized"),
                  value: settingsProvider.underSpendingAlertsEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleUnderSpendingAlerts(),
                ),
              ),

              const SizedBox(height: 10),

              // Low Budget Balance Alerts Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Low Budget Balance Alerts"),
                  subtitle: const Text("Get alerts when budget balance is low"),
                  value: settingsProvider.lowBudgetBalanceAlertsEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleLowBudgetBalanceAlerts(),
                ),
              ),

              const SizedBox(height: 10),

              // Account Security Alerts Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Account Security Alerts"),
                  subtitle: const Text(
                      "Get notifications about unusual login activity"),
                  value: settingsProvider.accountSecurityAlertsEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleAccountSecurityAlerts(),
                ),
              ),

              const SizedBox(height: 10),

              // Spending Pattern Alerts Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Spending Pattern Alerts"),
                  subtitle:
                      const Text("Get notices when spending patterns change"),
                  value: settingsProvider.spendingPatternAlertsEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleSpendingPatternAlerts(),
                ),
              ),

              const SizedBox(height: 10),

              // Data Synchronization Status Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Data Synchronization Status"),
                  subtitle:
                      const Text("Get notifications when data is synchronized"),
                  value: settingsProvider.dataSyncAlertsEnabled,
                  onChanged: (value) => settingsProvider.toggleDataSyncAlerts(),
                ),
              ),

              const SizedBox(height: 10),

              // Monthly Budget Comparison Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Monthly Budget Comparison"),
                  subtitle: const Text("Get monthly spending comparisons"),
                  value: settingsProvider.monthlyBudgetComparisonEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleMonthlyBudgetComparison(),
                ),
              ),

              const SizedBox(height: 10),

              // Bill Payment Reminders Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Bill Payment Reminders"),
                  subtitle: const Text("Get reminders for upcoming bills"),
                  value: settingsProvider.billPaymentRemindersEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleBillPaymentReminders(),
                ),
              ),

              const SizedBox(height: 10),

              // Saving Goal Progress Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Saving Goal Progress"),
                  subtitle: const Text("Get updates on your saving goals"),
                  value: settingsProvider.savingGoalProgressEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleSavingGoalProgress(),
                ),
              ),

              const SizedBox(height: 10),

              // Emergency Fund Alerts Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Emergency Fund Alerts"),
                  subtitle: const Text("Get alerts about low emergency funds"),
                  value: settingsProvider.emergencyFundAlertsEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleEmergencyFundAlerts(),
                ),
              ),

              const SizedBox(height: 10),

              // Data Backup Reminders Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Data Backup Reminders"),
                  subtitle: const Text("Get reminders to backup your data"),
                  value: settingsProvider.dataBackupRemindersEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleDataBackupReminders(),
                ),
              ),

              const SizedBox(height: 10),

              // Category Optimization Suggestions Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Category Optimization Suggestions"),
                  subtitle: const Text(
                      "Get suggestions for better budget categories"),
                  value:
                      settingsProvider.categoryOptimizationSuggestionsEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleCategoryOptimizationSuggestions(),
                ),
              ),

              const SizedBox(height: 10),

              // Financial Health Score Updates Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Financial Health Score Updates"),
                  subtitle: const Text(
                      "Get updates about your financial health score"),
                  value: settingsProvider.financialHealthScoreUpdatesEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleFinancialHealthScoreUpdates(),
                ),
              ),

              const SizedBox(height: 10),

              // Holiday Spending Alerts Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Holiday Spending Alerts"),
                  subtitle:
                      const Text("Get alerts during holiday spending seasons"),
                  value: settingsProvider.holidaySpendingAlertsEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleHolidaySpendingAlerts(),
                ),
              ),

              const SizedBox(height: 10),

              // Tax Season Alerts Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Tax Season Alerts"),
                  subtitle: const Text("Get reminders during tax season"),
                  value: settingsProvider.taxSeasonAlertsEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleTaxSeasonAlerts(),
                ),
              ),

              const SizedBox(height: 10),

              // Year-End Financial Review Toggle
              Card(
                child: SwitchListTile(
                  title: const Text("Year-End Financial Review"),
                  subtitle: const Text("Get annual financial summaries"),
                  value: settingsProvider.yearEndFinancialReviewEnabled,
                  onChanged: (value) =>
                      settingsProvider.toggleYearEndFinancialReview(),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
