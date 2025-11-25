import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class UserRepository {
  final AuthService _authService = AuthService();

  UserModel? getCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    return UserModel(uid: user.uid, email: user.email ?? "");
  }

  Future<UserModel?> login(String email, String password) async {
    final user = await _authService.login(email, password);
    if (user != null) {
      return UserModel(uid: user.uid, email: user.email ?? "");
    }
    return null;
  }

  Future<UserModel?> register(String email, String password) async {
    final user = await _authService.register(email, password);
    if (user != null) {
      return UserModel(uid: user.uid, email: user.email ?? "");
    }
    return null;
  }

  Future<void> logout() {
    return _authService.logout();
  }

  Future<void> sendPasswordReset(String email) {
    return _authService.resetPassword(email);
  }
}
