import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../state/settings_provider.dart';
import '../../state/auth_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Consumer<SettingsProvider>(
            builder: (context, _, child) {
              final currentUser = FirebaseAuth.instance.currentUser;
              return Column(
                children: [
                  if (currentUser != null)
                    // Account Card for logged-in users - appears at the very top
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0A7F66).withOpacity(0.1), // Light Emerald Deep Green
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: const Color(0xFF0A7F66), // Emerald Deep Green
                                      width: 1,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Color(0xFF0A7F66), // Emerald Deep Green
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentUser.email ?? "User",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0A7F66), // Emerald Deep Green
                                        ),
                                      ),
                                      Text(
                                        "Account Settings",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A7F66).withOpacity(0.1), // Light Emerald Deep Green
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Icon(
                                  Icons.security,
                                  color: const Color(0xFF0A7F66), // Emerald Deep Green
                                  size: 18,
                                ),
                              ),
                              title: const Text(
                                "Security Settings",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF0A7F66), // Emerald Deep Green
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                // Navigate to security settings
                              },
                            ),
                            const Divider(),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A7F66).withOpacity(0.1), // Light Emerald Deep Green
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Icon(
                                  Icons.privacy_tip,
                                  color: const Color(0xFF0A7F66), // Emerald Deep Green
                                  size: 18,
                                ),
                              ),
                              title: const Text(
                                "Privacy Policy",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF0A7F66), // Emerald Deep Green
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                // Navigate to privacy policy
                              },
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF0A7F66), Color(0xFF076C72)], // Emerald Deep Green to Teal
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  if (context.mounted) {
                                    context.go('/');
                                  }
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Sign Out",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )

                  else
                    // Empty space when user is not logged in to maintain structure
                    const SizedBox(),

                  const SizedBox(height: 10),

                  // PIN Security Setting - Appears at the top for non-logged-in users, second for logged-in
                  Card(
                    elevation: 2, // Set a consistent elevation
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Security",
                            style:
                                TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0A7F66)), // Emerald Deep Green
                          ),
                          const SizedBox(height: 10),
                          Consumer<SettingsProvider>(
                            builder: (context, settingsProvider, child) {
                              // Need to get the pin status differently since it's not in SettingsProvider
                              // For now, I'll keep it as a separate component
                              bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

                              return FutureBuilder<bool>(
                                future: _checkPinStatus(),
                                builder: (context, snapshot) {
                                  bool pinEnabled = snapshot.data ?? false;
                                  return SwitchListTile(
                                    title: const Text("Enable PIN Lock"),
                                    value: isLoggedIn ? pinEnabled : false, // Disable if not logged in
                                    onChanged: isLoggedIn ? (value) async {
                                      if (value) {
                                        // Enable PIN
                                        context.push('/set-pin');
                                      } else {
                                        // Disable PIN
                                        await _removePin();
                                        // Rebuild to update the switch
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text("PIN removed successfully")),
                                          );
                                        }
                                      }
                                    } : null, // Disable if not logged in
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
                    elevation: 2, // Set a consistent elevation
                    child: Consumer<SettingsProvider>(
                      builder: (context, settingsProvider, child) {
                        return SwitchListTile(
                          title: Text("Dark Mode",
                            style: TextStyle(
                              color: const Color(0xFF0A7F66), // Emerald Deep Green
                            ),
                          ),
                          value: settingsProvider.isDarkMode,
                          onChanged: (value) => settingsProvider.toggleTheme(),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Notification Settings
                  Card(
                    elevation: 2, // Set a consistent elevation
                    child: ListTile(
                      title: Text("Notifications",
                        style: TextStyle(
                          color: const Color(0xFF0A7F66), // Emerald Deep Green
                        ),
                      ),
                      trailing: Icon(Icons.notifications, color: const Color(0xFF0A7F66)), // Emerald Deep Green
                      onTap: () {
                        context.push('/settings/notifications');
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Export Data
                  Card(
                    elevation: 2, // Set a consistent elevation
                    child: ListTile(
                      title: Text("Export Data",
                        style: TextStyle(
                          color: const Color(0xFF0A7F66), // Emerald Deep Green
                        ),
                      ),
                      trailing: Icon(Icons.download, color: const Color(0xFF0A7F66)), // Emerald Deep Green
                      onTap: () {
                        context.push('/export');
                      },
                    ),
                  ),

                  // Login/Register buttons at the bottom when not logged in
                  if (currentUser == null) ...[
                    const Spacer(), // Push login buttons to bottom
                    const SizedBox(height: 20),
                    Card(
                      elevation: 2,
                      child: ListTile(
                        title: const Text("Login"),
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A7F66).withOpacity(0.1), // Light Emerald Deep Green
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.login,
                            color: const Color(0xFF0A7F66), // Emerald Deep Green
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          context.push('/login');
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 2,
                      child: ListTile(
                        title: const Text("Register"),
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A7F66).withOpacity(0.1), // Light Emerald Deep Green
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.app_registration,
                            color: const Color(0xFF0A7F66), // Emerald Deep Green
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          context.push('/register');
                        },
                      ),
                    ),
                  ],
                ], // Close the main children list
              ); // End the builder return
            }, // End the Consumer builder
          ), // End the Consumer
        ), // End the Padding
      ), // End the Container
    ); // End the Scaffold
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
