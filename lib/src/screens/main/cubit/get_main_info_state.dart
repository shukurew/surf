part of 'get_main_info_cubit.dart';

@immutable
sealed class GetMainInfoState {}

final class GetMainInfoInitial extends GetMainInfoState {}

final class GetMainInfoLoading extends GetMainInfoState {}

final class GetMainInfoLoaded extends GetMainInfoState {
  final int ok;
  final int notOk;

  GetMainInfoLoaded(this.ok, this.notOk);
}

final class GetMainInfoError extends GetMainInfoState {
  final String message;

  GetMainInfoError(this.message);
}
