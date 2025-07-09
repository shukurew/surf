import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tms/src/common/models/attendance/attendance_day.dart';

part 'attendance_response.g.dart';
part 'attendance_response.freezed.dart';

@freezed
class AttendanceResponse with _$AttendanceResponse {
  const factory AttendanceResponse({
    required bool success,
    required String message,
    required List<AttendanceDay>? data,
  }) = _AttendanceResponse;

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendanceResponseFromJson(json);
}
