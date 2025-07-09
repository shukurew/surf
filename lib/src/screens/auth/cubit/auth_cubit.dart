import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms/src/common/models/auth/auth_response.dart';
import 'package:tms/src/common/services/auth_service.dart';
import 'package:tms/src/common/services/auth_local_service.dart';
import 'package:tms/src/common/router/router.dart';
import 'package:tms/src/common/router/routing_constant.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tms/src/common/services/local_storage_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  final LocalStorageService localStorageService;
  final LocalAuthentication _localAuth;
  static const String _pinCodeKey = 'pin_code';
  static const int _maxPinAttempts = 3;
  int _pinAttempts = 0;

  AuthCubit({
    required this.authService,
    required this.localStorageService,
    LocalAuthentication? localAuth,
    FlutterSecureStorage? secureStorage,
  }) : _localAuth = localAuth ?? LocalAuthentication(),
       super(AuthInitial());

  Future<void> resetPinAttempts() async {
    _pinAttempts = 0;
  }

  void authNumber(String number, String password) async {
    emit(AuthLoading());
    try {
      AuthResponse response = await authService.authNumber(number, password);
      await localStorageService.write(
        key: 'access_token',
        data: response.accessToken,
      );
      await localStorageService.write(
        key: 'user',
        data: jsonEncode(response.user.toJson()),
      );
      await AuthLocalService().saveCredentials(number, password);

      emit(AuthLoaded());
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          emit(AuthFailed('Connection timed out'));
        case DioExceptionType.badResponse:
          emit(
            AuthFailed('Received invalid status: ${e.response?.statusCode}'),
          );
        case DioExceptionType.unknown:
          emit(AuthFailed('Something went wrong: ${e.message}'));
        default:
          emit(AuthFailed('Dio error: ${e.message}'));
      }
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  Future<void> authenticateWithBiometrics() async {
    try {
      final canAuthenticate = await _localAuth.canCheckBiometrics;
      if (!canAuthenticate) {
        emit(AuthFailed('Биометрическая аутентификация недоступна'));
        return;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Пожалуйста, подтвердите свою личность',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      if (didAuthenticate) {
        final creds = await AuthLocalService().getCredentials();
        if (creds['login'] != null && creds['password'] != null) {
          authNumber(creds['login']!, creds['password']!);
        } else {
          emit(AuthFailed('Учетные данные не найдены'));
        }
      } else {
        emit(AuthFailed('Аутентификация не удалась'));
      }
    } catch (e) {
      emit(AuthFailed('Ошибка аутентификации: $e'));
    }
  }

  Future<void> savePinCode(String pin) async {
    try {
      await localStorageService.write(key: _pinCodeKey, data: pin);
      _pinAttempts = 0;
      emit(PinCodeSaved());

      if (navigatorKey.currentContext != null) {
        Navigator.of(
          navigatorKey.currentContext!,
          rootNavigator: true,
        ).pushNamedAndRemoveUntil(RoutingConst.main, (_) => false);
      }
    } catch (e) {
      emit(AuthFailed('Ошибка при сохранении PIN-кода: $e'));
    }
  }

  Future<void> verifyPinCode(String pin) async {
    try {
      final savedPin = await localStorageService.read(_pinCodeKey);

      if (savedPin == pin) {
        _pinAttempts = 0;
        final creds = await AuthLocalService().getCredentials();
        if (creds['login'] != null && creds['password'] != null) {
          authNumber(creds['login']!, creds['password']!);
        } else {
          emit(AuthFailed('Учетные данные не найдены'));
        }
      } else {
        _pinAttempts++;
        if (_pinAttempts >= _maxPinAttempts) {
          emit(PinCodeBlocked());
        } else {
          emit(
            AuthFailed(
              'Неверный PIN-код. Осталось попыток: ${_maxPinAttempts - _pinAttempts}',
            ),
          );
        }
      }
    } catch (e) {
      emit(AuthFailed('Ошибка при проверке PIN-кода: $e'));
    }
  }

  void checkForPinCode() async {
    try {
      final savedPin = await localStorageService.read(_pinCodeKey);
      if (savedPin != null) {
        emit(AuthLoaded());
      } else {
        emit(AuthFailed(''));
      }
    } catch (e) {
      log('Exception:\n$e');
      emit(AuthFailed(''));
    }
  }
}
