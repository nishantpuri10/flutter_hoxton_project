import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

enum AuthStatus { idle, loading, authenticated, error }

class AuthProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;
  bool _rememberMe = false;
  String _savedEmail = '';
  String _savedPassword = '';

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;
  String get savedEmail => _savedEmail;
  String get savedPassword => _savedPassword;
  bool get isLoading => _status == AuthStatus.loading;

  Future<void> loadSavedCredentials() async {
    final credentials = await _storageService.getSavedCredentials();
    if (credentials['rememberMe'] == 'true') {
      _rememberMe = true;
      _savedEmail = credentials['email'] ?? '';
      _savedPassword = credentials['password'] ?? '';
      notifyListeners();
    }
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    // Simulate network call — replace with real API call
    await Future.delayed(const Duration(seconds: 2));

    // Placeholder credential check
    if (email.isNotEmpty && password.isNotEmpty) {
      if (_rememberMe) {
        await _storageService.saveCredentials(
          email: email,
          password: password,
        );
      } else {
        await _storageService.clearCredentials();
      }
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Please enter valid credentials.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _storageService.clearCredentials();
    _status = AuthStatus.idle;
    _rememberMe = false;
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
