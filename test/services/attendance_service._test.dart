import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tms/src/common/models/attendance/attendance_response.dart';
import 'package:tms/src/common/services/attendance_service.dart';

import '../mocks/mock_nv_dio.dart';

void main() {
  late MockNvDio mockNvDio;
  late MockDio mockDio;
  late AttendanceServiceImplement attendanceService;

  group('Attendance service', () {
    setUp(() {
      mockNvDio = MockNvDio();
      mockDio = MockDio();
      when(() => mockNvDio.dio).thenReturn(mockDio);
      attendanceService = AttendanceServiceImplement(mockNvDio);
    });

    test('successfully fetches AttendanceDays', () async {
      final from = DateTime(2025, 1, 1);
      final to = DateTime(2025, 1, 10);

      final mockResponseData = {
        "success": true,
        "message": "",
        "data": [
          {
            "id": 1,
            "employee": {"ext_id": 1, "full_name": "John Smith"},
            "date": "2025-05-22",
            "start_time": "07:56",
            "is_start_ok": true,
            "end_time": "17:05",
            "is_end_ok": true,
            "work_hours": "09:08:42",
            "is_day_off": false,
          },
        ],
      };

      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: mockResponseData,
          statusCode: 200,
        ),
      );

      final result = await attendanceService.getAttendanceList(from, to);

      expect(result, isA<AttendanceResponse>());
      expect(result.data![0].employee.fullName, "John Smith");
    });

    test('throws exception on 403', () async {
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 403,
          ),
          requestOptions: RequestOptions(path: ''),
        ),
      );

      expect(
        () async => await attendanceService.getAttendanceList(
          DateTime.now(),
          DateTime.now(),
        ),
        throwsA(predicate((e) => e.toString().contains('Не авторизовано'))),
      );
    });

    test('throws exception on time out', () async {
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      expect(
        () async => await attendanceService.getAttendanceList(
          DateTime.now(),
          DateTime.now(),
        ),
        throwsA(
          predicate((e) => e.toString().contains('Connection timed out')),
        ),
      );
    });
  });
}
