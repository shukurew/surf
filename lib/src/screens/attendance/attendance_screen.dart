import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms/src/common/constants/color_constant.dart';
import 'package:tms/src/common/constants/text_styles.dart';
import 'package:tms/src/screens/attendance/cubit/select_period_cubit.dart';
import 'package:tms/src/screens/attendance/widgets/attendance_headings.dart';
import 'package:tms/src/screens/attendance/widgets/attendance_list.dart';
import 'package:tms/src/screens/attendance/widgets/period_picker_button.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Дисциплина', style: TextStyles.head),
            SizedBox(height: 16),
            PeriodPickerButton(),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(12),
              child: AttendanceHeadings(),
            ),
            Flexible(
              child: BlocBuilder<SelectPeriodCubit, SelectPeriodState>(
                builder: (context, state) {
                  switch (state) {
                    case SelectPeriodInitial():
                    case SelectPeriodLoading():
                      return Align(
                        alignment: Alignment(0, -.5),
                        child: CircularProgressIndicator(color: AppColors.lime),
                      );
                    case SelectPeriodLoaded():
                      if (state.days.isEmpty) {
                        return Column(
                          spacing: 20,
                          children: [
                            Image.asset('assets/images/nothing_found.png'),
                            Text('Ничего не найдено.'),
                          ],
                        );
                      }
                      return AttendanceList(days: state.days);
                    case SelectPeriodFailed():
                      return Text(state.message);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
