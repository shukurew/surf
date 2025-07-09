import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:tms/src/common/models/attendance/attendance_response.dart';
import 'package:tms/src/common/services/attendance_service.dart';
import 'package:tms/src/screens/attendance/cubit/select_period_cubit.dart';
import 'package:tms/src/screens/attendance/widgets/time_periods.dart';

class MockAttendanceService extends Mock implements AttendanceService {}

void main() {
  late MockAttendanceService mockService;
  late AttendanceResponse sampleResponse;

  setUp(() {
    mockService = MockAttendanceService();
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
    sampleResponse = AttendanceResponse.fromJson(mockResponseData);
  });

  group('SelectPeriodCubit', () {
    blocTest<SelectPeriodCubit, SelectPeriodState>(
      'emits [Loading, Loaded] on successful getInitialData',
      build: () {
        when(
          () => mockService.getAttendanceList(any(), any()),
        ).thenAnswer((_) async => sampleResponse);
        return SelectPeriodCubit(mockService);
      },
      act: (cubit) => cubit.getInitialData(),

      expect:
          () => [
            isA<SelectPeriodLoading>(),
            isA<SelectPeriodLoaded>().having(
              (response) => response.days.length,
              'Days length',
              1,
            ),
          ],
    );

    blocTest<SelectPeriodCubit, SelectPeriodState>(
      'emits [Loading, Failed] on DioException in getInitialData',
      build: () {
        when(() => mockService.getAttendanceList(any(), any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            message: "Ошибка подключения",
          ),
        );
        return SelectPeriodCubit(mockService);
      },
      act: (cubit) => cubit.getInitialData(),
      expect:
          () => [
            isA<SelectPeriodLoading>(),
            isA<SelectPeriodFailed>().having(
              (state) => state.message,
              'message',
              contains('Ошибка подключения'),
            ),
          ],
    );

    blocTest<SelectPeriodCubit, SelectPeriodState>(
      'emits [Loading, Loaded] when selecting TimePeriod.year',
      build: () {
        when(
          () => mockService.getAttendanceList(any(), any()),
        ).thenAnswer((_) async => sampleResponse);
        return SelectPeriodCubit(mockService);
      },
      act: (cubit) => cubit.selectPeriod(TimePeriod.year),
      expect:
          () => [
            isA<SelectPeriodLoading>(),
            isA<SelectPeriodLoaded>().having(
              (response) => response.days.length,
              'Days length',
              1,
            ),
          ],
    );

    blocTest<SelectPeriodCubit, SelectPeriodState>(
      'emits [Loading, Loaded] when selecting custom period',
      build: () {
        when(
          () => mockService.getAttendanceList(any(), any()),
        ).thenAnswer((_) async => sampleResponse);
        return SelectPeriodCubit(mockService);
      },
      act:
          (cubit) => cubit.selectPeriod(
            TimePeriod.custom,
            datePeriod: DatePeriod(DateTime(2025, 1, 1), DateTime(2025, 1, 15)),
          ),
      expect:
          () => [
            isA<SelectPeriodLoading>(),
            isA<SelectPeriodLoaded>().having(
              (response) => response.days.length,
              'Days length',
              1,
            ),
          ],
    );
  });
}
