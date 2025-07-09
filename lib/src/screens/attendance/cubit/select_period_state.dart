part of 'select_period_cubit.dart';

sealed class SelectPeriodState {}

class SelectPeriodInitial extends SelectPeriodState {}

class SelectPeriodLoading extends SelectPeriodState {}

class SelectPeriodLoaded extends SelectPeriodState {
  SelectPeriodLoaded(this.days);

  final List<AttendanceDay> days;
}

class SelectPeriodFailed extends SelectPeriodState {
  SelectPeriodFailed(this.message);

  final String message;
}
