import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tms/src/common/dependencies/nv_dio.dart';
import 'package:tms/src/common/models/auth/auth_response.dart';

abstract class AuthService {
  Future<AuthResponse> authNumber(String number, String password);
  Future<void> logout();
  Future<String> requestPasswordReset(String phone);
  Future<String> verifyResetCode(String phone, String code);
  Future<String> resetPassword(
    String phone,
    String code,
    String newPassword,
    String newPasswordConfirmation,
  );
}

class AuthServiceImplement extends AuthService {
  AuthServiceImplement({required NvDio nvDio}) {
    dio = nvDio.dio;
  }
  late final Dio dio;

  final Box tokensBox = Hive.box('tokens');
  final Box userBox = Hive.box('user');

  @override
  Future<AuthResponse> authNumber(String number, String password) async {
    try {
      Response response = await dio.post(
        'v1/login-erp',
        data: {'phone': number, 'password': password},
      );

      AuthResponse authResponse = AuthResponse.fromJson(response.data);

      await tokensBox.put('access_token', authResponse.accessToken);
      await userBox.put('user', authResponse.user.toJson());

      return authResponse;
    } on DioException catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      rethrow;
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post('logout');
      await Hive.box('tokens').clear();
      await Hive.box('user').clear();
    } on DioException catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      throw DioException(
        error: e,
        requestOptions: RequestOptions(path: 'logout'),
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<String> requestPasswordReset(String phone) async {
    try {
      log('Requesting password reset for phone: $phone');
      log('URL: ${dio.options.baseUrl}v1/auth/forgot-password-erp');

      final response = await dio.post(
        'v1/auth/forgot-password-erp',
        data: {'phone': phone},
      );

      log('Response data: ${response.data}');

      if (response.data == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Пустой ответ от сервера',
        );
      }

      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true) {
        return data['data'] as String;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: data['message'] ?? 'Ошибка при запросе сброса пароля',
        );
      }
    } on DioException catch (e, stackTrace) {
      log('DioException: ${e.message}');
      log('Response: ${e.response?.data}');
      await Sentry.captureException(e, stackTrace: stackTrace);
      rethrow;
    } catch (e, stackTrace) {
      log('Unexpected error: $e');
      await Sentry.captureException(e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<String> verifyResetCode(String phone, String code) async {
    try {
      final response = await dio.post(
        'v1/auth/confirm-sms-code',
        data: {'phone': phone, 'code': code},
      );

      if (response.data == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Пустой ответ от сервера',
        );
      }

      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true) {
        return data['data'] as String;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: data['message'] ?? 'Ошибка при проверке кода',
        );
      }
    } on DioException catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<String> resetPassword(
    String phone,
    String code,
    String newPassword,
    String newPasswordConfirmation,
  ) async {
    try {
      final response = await dio.post(
        'v1/auth/change-password',
        data: {
          'phone': phone,
          'code': code,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
      );

      if (response.data == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Пустой ответ от сервера',
        );
      }

      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true) {
        return data['message'] as String;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: data['message'] ?? 'Ошибка при смене пароля',
        );
      }
    } on DioException catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
