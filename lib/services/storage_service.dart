import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  static const _keyEmail = 'hoxton_email';
  static const _keyPassword = 'hoxton_password';
  static const _keyRememberMe = 'hoxton_remember_me';

  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await _storage.write(key: _keyEmail, value: email);
    await _storage.write(key: _keyPassword, value: password);
    await _storage.write(key: _keyRememberMe, value: 'true');
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: _keyEmail);
    await _storage.delete(key: _keyPassword);
    await _storage.write(key: _keyRememberMe, value: 'false');
  }

  Future<Map<String, String?>> getSavedCredentials() async {
    final email = await _storage.read(key: _keyEmail);
    final password = await _storage.read(key: _keyPassword);
    final rememberMe = await _storage.read(key: _keyRememberMe);
    return {
      'email': email,
      'password': password,
      'rememberMe': rememberMe,
    };
  }

  Future<bool> hasRememberMe() async {
    final value = await _storage.read(key: _keyRememberMe);
    return value == 'true';
  }
}
