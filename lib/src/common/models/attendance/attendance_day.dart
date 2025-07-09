import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tms/src/common/models/attendance/employee.dart';

part 'attendance_day.g.dart';
part 'attendance_day.freezed.dart';

@freezed
class AttendanceDay with _$AttendanceDay {
  const factory AttendanceDay({
    required int id,
    required Employee employee,
    required String date,
    @JsonKey(name: 'start_time') required String? startTime,
    @JsonKey(name: 'is_start_ok') required bool? isStartOk,
    @JsonKey(name: 'end_time') required String? endTime,
    @JsonKey(name: 'is_end_ok') required bool? isEndOk,
    @JsonKey(name: 'work_hours') required String workHours,
    @JsonKey(name: 'is_day_off') required bool isDayOff,
  }) = _AttendanceDay;

  factory AttendanceDay.fromJson(Map<String, dynamic> json) =>
      _$AttendanceDayFromJson(json);
}
