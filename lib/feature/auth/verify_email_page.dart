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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                // Email Icon
                Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.email_outlined,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                // Title and Description
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Text(
                        "Verify Your Email",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "We've sent a verification link to your email address. Please check your inbox and click the link to verify your account.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Status indicator
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      if (_checkingVerification)
                        Column(
                          children: [
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Checking verification status...",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Please check your email",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        )
                      else if (isEmailVerified)
                        Column(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 60,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Email Verified!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Redirecting...",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Resend Email Button
                SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: _checkingVerification ? null : sendVerificationEmail,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      "Resend Verification Email",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Sign Out Button
                TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    context.go('/');
                  },
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
