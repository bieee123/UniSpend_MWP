import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Check if PIN is set and navigate appropriately
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3)); // Wait 3 seconds for the splash screen

    if (mounted) {
      final prefs = await SharedPreferences.getInstance();
      final hasPin = prefs.getString('pin') != null;
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;

      if (hasPin && isLoggedIn) {
        // If user has set a PIN and is logged in, redirect to PIN verification
        context.go('/verify-pin?next=/transactions');
      } else {
        // If no PIN is set or user is not logged in, go directly to transaction page
        // If not logged in, user will need to login first, then they can set PIN
        context.go('/transactions');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A7F66), // Emerald Deep Green
              Color(0xFF076C72), // Teal Forest
              Color(0xFF0BB28E), // Green Sea Mix
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30), // Rounded style
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  size: 60,
                  color: Colors.white, // Light teal/white for contrast
                ),
              ),
              const SizedBox(height: 40),
              // App Name
              Text(
                "UniSpend",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Colors.white, // White text for contrast
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Financial Tracking Made Simple",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9), // Light mint text
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}