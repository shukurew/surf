part of 'auth_cubit_out.dart';

@immutable
abstract class AuthStateOut {}

class AuthInitial extends AuthStateOut {}

class Authentificated extends AuthStateOut {}

class UnAuthentificated extends AuthStateOut {}
