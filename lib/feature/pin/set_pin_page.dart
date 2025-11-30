import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class SetPINPage extends StatefulWidget {
  const SetPINPage({super.key});

  @override
  State<SetPINPage> createState() => _SetPINPageState();
}

class _SetPINPageState extends State<SetPINPage> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  bool _obscurePin = true;
  bool _obscureConfirmPin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set PIN")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Set a 4-6 digit PIN to secure your app",
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
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _confirmPinController,
              obscureText: _obscureConfirmPin,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'Confirm PIN',
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPin ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPin = !_obscureConfirmPin;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _setPIN,
              child: const Text("Set PIN"),
            ),
          ],
        ),
      ),
    );
  }

  void _setPIN() async {
    String pin = _pinController.text.trim();
    String confirmPin = _confirmPinController.text.trim();

    if (pin.length < 4 || pin.length > 6) {
      _showErrorDialog("PIN must be 4-6 digits long");
      return;
    }

    if (pin != confirmPin) {
      _showErrorDialog("PINs do not match");
      return;
    }

    // Hash the PIN for secure storage
    String hashedPIN = sha256.convert(utf8.encode(pin)).toString();

    // Save to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', hashedPIN);

    // Navigate back to settings or wherever appropriate
    if (mounted) {
      // Show success message first
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("PIN set successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Wait a bit to show the success message before navigating
      await Future.delayed(const Duration(milliseconds: 500));

      Navigator.pop(context);
    }
  }

  void _showErrorDialog(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }
}