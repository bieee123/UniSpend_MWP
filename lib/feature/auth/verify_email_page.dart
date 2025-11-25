import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool _checkingVerification = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Check if email is already verified
    checkEmailVerification();

    // Send initial email verification if not verified
    sendVerificationEmail();

    // Start checking periodically if email is verified
    startEmailVerificationTimer();
  }

  void checkEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload(); // Reload user to get fresh data
      setState(() {
        isEmailVerified = user.emailVerified;
        _checkingVerification = false;
      });

      if (user.emailVerified) {
        // Navigate to dashboard if verified
        if (mounted) {
          context.go('/dashboard');
        }
      }
    }
  }

  void sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  void startEmailVerificationTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        if (user.emailVerified) {
          setState(() {
            isEmailVerified = true;
            _checkingVerification = false;
          });

          // Navigate to dashboard when verified
          if (mounted) {
            context.go('/dashboard');
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.email_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            const Text(
              "Email Verification Required",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "A verification link has been sent to your email address. Please check your inbox and click the link to verify your account.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (_checkingVerification)
              const CircularProgressIndicator()
            else if (isEmailVerified)
              const Text(
                "Email verified! Redirecting...",
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendVerificationEmail();
              },
              child: const Text("Resend Verification Email"),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                context.go('/');
              },
              child: const Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
