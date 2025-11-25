import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

class VerifyPINPage extends StatefulWidget {
  final String? nextRoute;
  
  const VerifyPINPage({super.key, this.nextRoute});

  @override
  State<VerifyPINPage> createState() => _VerifyPINPageState();
}

class _VerifyPINPageState extends State<VerifyPINPage> {
  final TextEditingController _pinController = TextEditingController();
  bool _obscurePin = true;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter PIN")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter your PIN to continue",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _pinController,
              obscureText: _obscurePin,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'Enter PIN',
                suffixIcon: IconButton(
                  icon: Icon(_obscurePin ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscurePin = !_obscurePin;
                    });
                  },
                ),
                errorText: _errorMessage.isEmpty ? null : _errorMessage,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _verifyPIN,
              child: const Text("Unlock"),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyPIN() async {
    String enteredPIN = _pinController.text.trim();

    if (enteredPIN.length < 4 || enteredPIN.length > 6) {
      setState(() {
        _errorMessage = "PIN must be 4-6 digits";
      });
      return;
    }

    // Hash the entered PIN
    String hashedEnteredPIN = sha256.convert(utf8.encode(enteredPIN)).toString();

    // Get stored PIN from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedHashedPIN = prefs.getString('pin');

    if (storedHashedPIN == null) {
      // If no PIN is set, navigate to set PIN page
      if (mounted) {
        context.go('/settings');
      }
      return;
    }

    if (hashedEnteredPIN == storedHashedPIN) {
      // PIN is correct, navigate to the next route
      if (widget.nextRoute != null && mounted) {
        context.go(widget.nextRoute!);
      } else if (mounted) {
        Navigator.pop(context); // Just pop if no specific route
      }
    } else {
      setState(() {
        _errorMessage = "Incorrect PIN";
      });
      _pinController.clear();
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
}