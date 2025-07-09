import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:tms/src/common/dependencies/nv_dio.dart';
import 'package:tms/src/common/models/attendance/attendance_response.dart';

abstract class AttendanceService {
  Future<AttendanceResponse> getAttendanceList(DateTime from, DateTime to);
}

class AttendanceServiceImplement extends AttendanceService {
  AttendanceServiceImplement(this._nvDio);

  final NvDio _nvDio;

  @override
  Future<AttendanceResponse> getAttendanceList(
    DateTime from,
    DateTime to,
  ) async {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    try {
      Response response = await _nvDio.dio.get(
        '/v1/new/events/list?date_from=${formatter.format(from)}&date_to=${formatter.format(to)}',
      );
      log(response.data.toString());
      AttendanceResponse attendance = AttendanceResponse.fromJson(
        response.data,
      );
      return attendance;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection timed out");
      } else if (e.response != null && e.response?.statusCode == 403) {
        throw Exception("Не авторизовано");
      } else if (e.response != null && e.response?.statusCode == 404) {
        throw Exception("Не найдено, проверьте даты");
      } else {
        throw Exception("Ошибка сети: ${e.message}");
      }
    } catch (e) {
      throw Exception("Непредвиденная ошибка: $e");
    }
  }
}
