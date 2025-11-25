import 'package:flutter/material.dart';
import '../data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _auth = AuthService();

  bool isLoading = false;

  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final user = await _auth.login(email, password);
      return user != null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final user = await _auth.register(email, password);
      if (user != null) {
        // Send email verification after registration
        await _auth.sendEmailVerification();
        return true;
      }
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.logout();
  }

  Future<void> sendEmailVerification() async {
    await _auth.sendEmailVerification();
  }

  Future<void> resetPassword(String email) async {
    await _auth.resetPassword(email);
  }
}
