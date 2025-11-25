import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../state/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // PIN Security Setting
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Security",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Consumer<SettingsProvider>(
                      builder: (context, settingsProvider, child) {
                        // Need to get the pin status differently since it's not in SettingsProvider
                        // For now, I'll keep it as a separate component
                        return FutureBuilder<bool>(
                          future: _checkPinStatus(),
                          builder: (context, snapshot) {
                            bool pinEnabled = snapshot.data ?? false;
                            return SwitchListTile(
                              title: const Text("Enable PIN Lock"),
                              value: pinEnabled,
                              onChanged: (value) async {
                                if (value) {
                                  // Enable PIN
                                  context.push('/set-pin');
                                } else {
                                  // Disable PIN
                                  await _removePin();
                                  // Rebuild to update the switch
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("PIN removed successfully")),
                                    );
                                  }
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Theme Settings
            Card(
              child: Consumer<SettingsProvider>(
                builder: (context, settingsProvider, child) {
                  return SwitchListTile(
                    title: const Text("Dark Mode"),
                    value: settingsProvider.isDarkMode,
                    onChanged: (value) => settingsProvider.toggleTheme(),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // Budget Settings
            Card(
              child: ListTile(
                title: const Text("Budget Limit"),
                trailing: const Icon(Icons.account_balance_wallet),
                onTap: () {
                  context.push('/budget-limit');
                },
              ),
            ),

            const SizedBox(height: 10),

            // Notification Settings
            Card(
              child: ListTile(
                title: const Text("Notifications"),
                trailing: const Icon(Icons.notifications),
                onTap: () {
                  context.push('/notification-settings');
                },
              ),
            ),

            const SizedBox(height: 10),

            // Export Data
            Card(
              child: ListTile(
                title: const Text("Export Data"),
                trailing: const Icon(Icons.download),
                onTap: () {
                  context.push('/export');
                },
              ),
            ),

            const SizedBox(height: 10),

            // Logout option
            Card(
              child: ListTile(
                title: const Text("Logout"),
                trailing: const Icon(Icons.logout),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    context.go('/');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkPinStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('pin') != null;
  }

  Future<void> _removePin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('pin');
  }
}
