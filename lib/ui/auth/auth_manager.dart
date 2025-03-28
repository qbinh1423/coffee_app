import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';

class AuthManager with ChangeNotifier {
  late final AuthService _authService;

  User? _loggedInUser;

  AuthManager() {
    _authService = AuthService(onAuthChange: (User? user) {
      _loggedInUser = user;
      notifyListeners();
    });
  }

  bool get isAuth {
    return _loggedInUser != null;
  }

  User? get user {
    return _loggedInUser;
  }

  Future<User> signup(
      String name, String email, String password, String phone) {
    return _authService.signup(name, email, phone, password);
  }

  Future<User> login(String email, String password) {
    return _authService.login(email, password);
  }

  Future<void> tryAutoLogin() async {
    final user = await _authService.getUserFromStore();
    if (user != null) {
      _loggedInUser = user;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    return _authService.logout();
  }

  Future<User> updateUser(Map<String, dynamic> updatedData) async {
    if (_loggedInUser == null) {
      throw Exception('No users are logged in.');
    }

    final updatedUser =
        await _authService.updateUser(_loggedInUser!.id, updatedData);

    _loggedInUser = updatedUser;
    notifyListeners();

    return updatedUser;
  }

  Future<bool> deleteUser(String userId) async {
    try {
      await _authService.deleteUser(userId);

      print('Delete user successfully: $userId');

      notifyListeners();
      return true;
    } catch (error) {
      print('Error when deleting user: $error');
      return false;
    }
  }

  Future<List<User>> fetchAllUsers() async {
    return await _authService.getAllUsers();
  }
}
