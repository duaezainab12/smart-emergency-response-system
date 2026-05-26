import 'package:flutter/material.dart';
import '../models/user_model.dart';

enum AuthStatus { idle, loading, authenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.idle;
  UserModel?  _currentUser;
  String      _errorMessage = '';

  // ── Getters ──────────────────────────────────────────────────────────────
  AuthStatus get status       => _status;
  UserModel? get currentUser  => _currentUser;
  String     get errorMessage => _errorMessage;
  bool get isLoggedIn         => _status == AuthStatus.authenticated;
  bool get isLoading          => _status == AuthStatus.loading;

  // ── Login ────────────────────────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    _setStatus(AuthStatus.loading);

    await Future.delayed(const Duration(milliseconds: 800)); // simulate network

    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Email and password are required.';
      _setStatus(AuthStatus.error);
      return false;
    }

    if (!email.contains('@')) {
      _errorMessage = 'Please enter a valid email address.';
      _setStatus(AuthStatus.error);
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters.';
      _setStatus(AuthStatus.error);
      return false;
    }

    // Simulate successful login — replace with real DB/API call
    _currentUser = UserModel(
      id: 'usr_001',
      name: email.split('@').first,
      email: email,
      password: '',          // never store raw password in state
      phone: '+92-300-0000000',
      role: 'user',
    );

    _errorMessage = '';
    _setStatus(AuthStatus.authenticated);
    return true;
  }

  // ── Logout ───────────────────────────────────────────────────────────────
  void logout() {
    _currentUser = null;
    _errorMessage = '';
    _setStatus(AuthStatus.idle);
  }

  // ── Clear error ──────────────────────────────────────────────────────────
  void clearError() {
    if (_status == AuthStatus.error) {
      _errorMessage = '';
      _setStatus(AuthStatus.idle);
    }
  }

  // ── Private helper ───────────────────────────────────────────────────────
  void _setStatus(AuthStatus s) {
    _status = s;
    notifyListeners();
  }
}