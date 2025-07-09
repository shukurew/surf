import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalService {
  static const _keyLogin = 'login';
  static const _keyPassword = 'password';

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> saveCredentials(String login, String password) async {
    try {
      await storage.write(key: _keyLogin, value: login);
      await storage.write(key: _keyPassword, value: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String?>> getCredentials() async {
    try {
      final login = await storage.read(key: _keyLogin);
      final password = await storage.read(key: _keyPassword);
      return {'login': login, 'password': password};
    } catch (e) {
      return {'login': null, 'password': null};
    }
  }

  Future<void> clearCredentials() async {
    try {
      await storage.delete(key: _keyLogin);
      await storage.delete(key: _keyPassword);
    } catch (e) {
      rethrow;
    }
  }
}
