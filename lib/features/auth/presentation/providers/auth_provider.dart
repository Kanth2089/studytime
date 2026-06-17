import 'package:flutter/material.dart';
import '../../data/auth_service.dart';
import '../../domain/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _currentUser;
  bool _isLoading = true; // true initially to show splash while checking session
  String? _errorMessage;
  bool _isEmailVerified = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isEmailVerified => true;

  AuthProvider() {
    checkCurrentUser();
  }

  // Check current user session
  Future<void> checkCurrentUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _authService.getCurrentUser();
      if (_currentUser != null) {
        _isEmailVerified = await _authService.isEmailVerified();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign In
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _authService.signIn(email, password);
      if (_currentUser != null) {
        _isEmailVerified = await _authService.isEmailVerified();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register
  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required String selectedGoal,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _authService.register(
        name: name,
        email: email,
        password: password,
        selectedGoal: selectedGoal,
      );
      if (_currentUser != null) {
        _isEmailVerified = await _authService.isEmailVerified();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Check Email Verification Status
  Future<void> checkEmailVerification() async {
    _isLoading = true;
    notifyListeners();
    try {
      _isEmailVerified = await _authService.isEmailVerified();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Send Email Verification Link
  Future<void> sendVerificationEmail() async {
    try {
      await _authService.sendEmailVerification();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Password Reset
  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reload user profile data to reflect new scores
  Future<void> reloadUserData() async {
    if (_currentUser != null) {
      final updatedUser = await _authService.getUserData(_currentUser!.uid);
      if (updatedUser != null) {
        _currentUser = updatedUser;
        notifyListeners();
      }
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signOut();
      _currentUser = null;
      _isEmailVerified = false;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
