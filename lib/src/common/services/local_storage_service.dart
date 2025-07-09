import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class LocalStorageService {
  Future<String?> read(String key);
  Future<void> write({required String key, required String data});
  Future<void> delete({required String key});
}

class SecureLocalStorageService implements LocalStorageService {
  SecureLocalStorageService() {
    _secureStorage = FlutterSecureStorage();
  }

  late final FlutterSecureStorage _secureStorage;

  @override
  Future<String?> read(String key) async {
    try {
      final data = await _secureStorage.read(key: key);
      return data;
    } catch (e, stacktrace) {
      log('$e\n$stacktrace');
      rethrow;
    }
  }

  @override
  Future<void> write({required String key, required String data}) async {
    try {
      await _secureStorage.write(key: key, value: data);
    } catch (e, stacktrace) {
      log('$e\n$stacktrace');
      rethrow;
    }
  }

  @override
  Future<void> delete({required String key}) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e, stacktrace) {
      log('$e\n$stacktrace');
      rethrow;
    }
  }
}
