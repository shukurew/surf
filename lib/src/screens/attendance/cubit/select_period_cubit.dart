import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:tms/src/common/models/attendance/attendance_day.dart';
import 'package:tms/src/common/models/attendance/attendance_response.dart';
import 'package:tms/src/common/services/attendance_service.dart';
import 'package:tms/src/screens/attendance/widgets/time_periods.dart';

part 'select_period_state.dart';

class SelectPeriodCubit extends Cubit<SelectPeriodState> {
  SelectPeriodCubit(this._attendanceService) : super(SelectPeriodInitial());

  final AttendanceService _attendanceService;

  TimePeriod selectedPeriod = TimePeriod.month;
  DateTime? from;
  DateTime? to;

  void getInitialData() async {
    emit(SelectPeriodLoading());
    try {
      DateTime today = DateTime.now();
      from = null;
      to = null;
      AttendanceResponse attendanceResponse = await _attendanceService
          .getAttendanceList(today.copyWith(day: 0), today);
      emit(SelectPeriodLoaded(attendanceResponse.data ?? []));
    } on DioException catch (e) {
      emit(SelectPeriodFailed(e.message.toString()));
    }
  }

  void selectPeriod(TimePeriod period, {DatePeriod? datePeriod}) async {
    emit(SelectPeriodLoading());
    try {
      selectedPeriod = period;
      _setFromToDates(datePeriod: datePeriod);
      AttendanceResponse attendanceResponse = await _attendanceService
          .getAttendanceList(from!, to!);
      emit(SelectPeriodLoaded(attendanceResponse.data ?? []));
    } on DioException catch (e) {
      emit(SelectPeriodFailed(e.message.toString()));
    }
  }

  void _setFromToDates({DatePeriod? datePeriod}) {
    to = DateTime.now();
    switch (selectedPeriod) {
      case TimePeriod.month:
        from = to!.copyWith(month: to!.month - 1);
        break;
      case TimePeriod.halfYear:
        from = to!.copyWith(month: to!.month - 6);
        break;
      case TimePeriod.year:
        from = to!.copyWith(year: to!.year - 1);
        break;
      case TimePeriod.custom:
        from = datePeriod!.start;
        to = datePeriod.end;
        break;
    }
  }
}
