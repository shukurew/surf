import 'dart:convert';

import 'package:tms/src/common/models/user/user.dart';
import 'package:tms/src/common/services/local_storage_service.dart';

abstract class UserStorageService {
  void saveToken(String token);
  void saveUser(User user);
  void clearToken();
  Future<String> getToken();
  Future<User> getUser();
}

class UserStorageServiceImplement extends UserStorageService {
  UserStorageServiceImplement(this._localStorageService);
  final LocalStorageService _localStorageService;

  final accessTokenKey = 'access_token';
  final userKey = 'user';

  @override
  void clearToken() async {
    await _localStorageService.delete(key: accessTokenKey);
  }

  @override
  Future<String> getToken() async {
    String? token = await _localStorageService.read(accessTokenKey);
    if (token == null) {
      throw Exception("Couldn't load access token. No token found!");
    }
    return token;
  }

  @override
  Future<User> getUser() async {
    String? userString = await _localStorageService.read(userKey);
    if (userString == null) {
      throw Exception("Couldn't load user data. No user data found!");
    }
    User user = User.fromJson(jsonDecode(userString));
    return user;
  }

  @override
  void saveToken(String token) async {
    await _localStorageService.write(key: accessTokenKey, data: token);
  }

  @override
  void saveUser(User user) async {
    await _localStorageService.write(
      key: userKey,
      data: jsonEncode(user.toJson()),
    );
  }
}
