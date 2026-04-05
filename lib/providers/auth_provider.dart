import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

enum AuthStatus { idle, loading, authenticated, error }

class AuthProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;

  // Two-step login flow
  String _pendingEmail = '';

  // Saved credentials (from secure storage)
  String _savedEmail = '';
  String _savedPassword = '';

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String get pendingEmail => _pendingEmail;
  String get savedEmail => _savedEmail;
  String get savedPassword => _savedPassword;
  bool get isLoading => _status == AuthStatus.loading;

  /// Called after email screen — stores email for use in password screen.
  void setPendingEmail(String email) {
    _pendingEmail = email;
    notifyListeners();
  }

  /// Called after password screen — saves credentials and marks authenticated.
  Future<bool> completeLogin({required String password}) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    // Simulate network call — replace with real API call
    await Future.delayed(const Duration(seconds: 2));

    if (_pendingEmail.isNotEmpty && password.isNotEmpty) {
      await _storageService.saveCredentials(
        email: _pendingEmail,
        password: password,
      );
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Something went wrong. Please try again.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadSavedCredentials() async {
    final credentials = await _storageService.getSavedCredentials();
    if (credentials['rememberMe'] == 'true') {
      _savedEmail = credentials['email'] ?? '';
      _savedPassword = credentials['password'] ?? '';
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _storageService.clearCredentials();
    _status = AuthStatus.idle;
    _pendingEmail = '';
    _savedEmail = '';
    _savedPassword = '';
    notifyListeners();
  }

  void resetStatus() {
    _status = AuthStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }
}
