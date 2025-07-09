import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms/src/common/dependencies/injection_container.dart';
import 'package:tms/src/common/widgets/modal_bottom_sheet.dart';
import 'package:tms/src/screens/attendance/cubit/select_period_cubit.dart';
import 'package:tms/src/screens/attendance/widgets/calendar_picker.dart';
import 'package:tms/src/screens/attendance/widgets/period_picker_option.dart';
import 'package:tms/src/screens/attendance/widgets/time_periods.dart';

class PeriodPicker extends StatelessWidget {
  const PeriodPicker({super.key});

  void _onPeriodSelected(BuildContext context, TimePeriod timePeriod) {
    if (timePeriod != TimePeriod.custom) {
      context.read<SelectPeriodCubit>().selectPeriod(timePeriod);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      showStyledModalBottomSheet(
        context,
        'За период',
        BlocProvider<SelectPeriodCubit>.value(
          value: getIt(),
          child: CalendarPicker(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return PeriodPickerOption(
          type: timePeriods[index]['type'],
          label: timePeriods[index]['text'],
          isSelected:
              context.read<SelectPeriodCubit>().selectedPeriod ==
              timePeriods[index]['type'],
          onTap: (timePeriod) => _onPeriodSelected(context, timePeriod),
        );
      },
      separatorBuilder:
          (context, index) => Divider(height: 1, color: Color(0xFFE7E7E8)),
      itemCount: timePeriods.length,
    );
  }
}
