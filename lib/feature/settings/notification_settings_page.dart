import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/settings_provider.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Notification Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Daily Reminder Toggle
            Card(
              child: SwitchListTile(
                title: const Text("Daily Reminder"),
                subtitle: const Text("Get reminded to record your spending daily"),
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
                subtitle: const Text("Get notified when you're close to your budget limit"),
                value: settingsProvider.budgetAlertsEnabled,
                onChanged: (value) => settingsProvider.toggleBudgetAlerts(),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Test Notification Button
            ElevatedButton(
              onPressed: () {
                // Implement test notification
              },
              child: const Text("Test Notification"),
            ),
          ],
        ),
      ),
    );
  }
}