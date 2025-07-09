import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms/src/common/services/auth_service.dart';

part 'reset_password_state.dart';

class RequestResetCubit extends Cubit<ResetPasswordState> {
  final AuthService authService;

  RequestResetCubit({required this.authService})
    : super(ResetPasswordInitial());

  Future<void> requestReset(String phone) async {
    emit(ResetPasswordLoading());
    try {
      final message = await authService.requestPasswordReset(phone);
      emit(ResetPasswordSuccess(message: message));
    } on DioException catch (e) {
      String errorMessage = 'Произошла ошибка';
      if (e.response?.data != null &&
          e.response?.data is Map<String, dynamic>) {
        final data = e.response?.data as Map<String, dynamic>;
        errorMessage = data['message'] ?? data['error'] ?? errorMessage;
      }
      emit(ResetPasswordError(message: errorMessage));
    } catch (e) {
      log(e.toString());
      emit(ResetPasswordError(message: e.toString()));
    }
  }
}

class VerifyCodeCubit extends Cubit<ResetPasswordState> {
  final AuthService authService;

  VerifyCodeCubit({required this.authService}) : super(ResetPasswordInitial());

  Future<void> verifyCode(String phone, String code) async {
    emit(ResetPasswordLoading());
    try {
      final message = await authService.verifyResetCode(phone, code);
      emit(ResetPasswordSuccess(message: message));
    } on DioException catch (e) {
      String errorMessage = 'Произошла ошибка';
      if (e.response?.data != null &&
          e.response?.data is Map<String, dynamic>) {
        final data = e.response?.data as Map<String, dynamic>;
        errorMessage = data['message'] ?? data['error'] ?? errorMessage;
      }
      emit(ResetPasswordError(message: errorMessage));
    } catch (e) {
      log(e.toString());
      emit(ResetPasswordError(message: e.toString()));
    }
  }
}

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthService authService;

  ResetPasswordCubit({required this.authService})
    : super(ResetPasswordInitial());

  Future<void> resetPassword(
    String phone,
    String code,
    String newPassword,
  ) async {
    emit(ResetPasswordLoading());
    try {
      final message = await authService.resetPassword(
        phone,
        code,
        newPassword,
        newPassword, // Подтверждение пароля
      );
      emit(ResetPasswordSuccess(message: message));
    } on DioException catch (e) {
      String errorMessage = 'Произошла ошибка';
      if (e.response?.data != null &&
          e.response?.data is Map<String, dynamic>) {
        final data = e.response?.data as Map<String, dynamic>;
        errorMessage = data['message'] ?? data['error'] ?? errorMessage;
      }
      emit(ResetPasswordError(message: errorMessage));
    } catch (e) {
      log(e.toString());
      emit(ResetPasswordError(message: e.toString()));
    }
  }
}
