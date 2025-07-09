part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {}

class AuthFailed extends AuthState {
  AuthFailed(this.message);

  final String message;
}

class PinCodeSaved extends AuthState {}

class AuthSuccess extends AuthState {}

class PinCodeBlocked extends AuthState {}
