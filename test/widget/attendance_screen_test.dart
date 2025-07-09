import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms/src/common/models/attendance/attendance_day.dart';
import 'package:tms/src/screens/attendance/attendance_screen.dart';
import 'package:tms/src/screens/attendance/cubit/select_period_cubit.dart';

class MockSelectPeriodCubit extends MockCubit<SelectPeriodState>
    implements SelectPeriodCubit {}

void main() {
  late MockSelectPeriodCubit mockCubit;

  late AttendanceDay exampleDay;

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      locale: Locale('ru'),
      supportedLocales: [Locale('ru')],
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: BlocProvider<SelectPeriodCubit>.value(
        value: mockCubit,
        child: child,
      ),
    );
  }

  group('AttendanceScreen', () {
    setUp(() {
      mockCubit = MockSelectPeriodCubit();
      exampleDay = AttendanceDay.fromJson({
        "id": 1,
        "employee": {"ext_id": 1, "full_name": "John Smith"},
        "date": "2025-05-22",
        "start_time": "07:56",
        "is_start_ok": true,
        "end_time": "17:05",
        "is_end_ok": true,
        "work_hours": "09:08:42",
        "is_day_off": false,
      });
    });

    testWidgets('shows CircularProgressIndicator on loading', (tester) async {
      when(() => mockCubit.state).thenReturn(SelectPeriodLoading());

      await tester.pumpWidget(makeTestableWidget(const AttendanceScreen()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows attendance list when successfuly loaded', (
      tester,
    ) async {
      when(() => mockCubit.state).thenReturn(SelectPeriodLoaded([exampleDay]));

      await tester.pumpWidget(makeTestableWidget(const AttendanceScreen()));
      await tester.pump(); // на случай анимаций или отложенной отрисовки

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('shows "Ничего не найдено" text on empty list', (tester) async {
      when(() => mockCubit.state).thenReturn(SelectPeriodLoaded([]));

      await tester.pumpWidget(makeTestableWidget(const AttendanceScreen()));

      expect(find.text('Ничего не найдено.'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('shows error message', (tester) async {
      when(
        () => mockCubit.state,
      ).thenReturn(SelectPeriodFailed("Ошибка загрузки"));

      await tester.pumpWidget(makeTestableWidget(const AttendanceScreen()));

      expect(find.text("Ошибка загрузки"), findsOneWidget);
    });
  });
}
