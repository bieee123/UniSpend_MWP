import 'package:flutter/material.dart';
import '../dashboard/dashboard_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, directly show dashboard without auth checking
    // This allows us to focus on other features
    return const DashboardPage();
  }
}