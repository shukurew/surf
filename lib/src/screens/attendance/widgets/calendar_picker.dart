import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:tms/src/common/constants/color_constant.dart';
import 'package:tms/src/common/constants/text_styles.dart';
import 'package:tms/src/screens/attendance/cubit/select_period_cubit.dart';
import 'package:tms/src/screens/attendance/widgets/time_periods.dart';

class CalendarPicker extends StatefulWidget {
  const CalendarPicker({super.key});

  @override
  State<CalendarPicker> createState() => _CalendarPickerState();
}

class _CalendarPickerState extends State<CalendarPicker> {
  late DatePeriod _datePeriod;
  DateTime today = DateTime.now();

  @override
  void initState() {
    _datePeriod = DatePeriod(today, today);
    super.initState();
  }

  void _selectCustomPeriod() {
    context.read<SelectPeriodCubit>().selectPeriod(
      TimePeriod.custom,
      datePeriod: _datePeriod,
    );
    Navigator.pop(context);
  }

  void _updateSelectedPeriod(datePeriod) {
    setState(() {
      _datePeriod = datePeriod;
    });
  }

  EventDecoration buildEventDecoration(date) {
    TextStyle textStyle = TextStyles.calendarDay;
    if (date.weekday >= 6) {
      textStyle = textStyle.copyWith(color: Color(0xFFB8B8B8));
    }
    if (date.isAfter(today)) {
      textStyle = textStyle.copyWith(color: Color(0xFFB8B8B8));
    }
    return EventDecoration(textStyle: textStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RangePicker(
            selectedPeriod: _datePeriod,
            firstDate: today.copyWith(year: today.year - 1),
            lastDate: today,
            datePickerLayoutSettings: DatePickerLayoutSettings(
              showPrevMonthEnd: true,
              showNextMonthStart: true,
            ),
            selectableDayPredicate: (dateTime) => true,
            datePickerStyles: DatePickerRangeStyles(
              defaultDateTextStyle: TextStyles.calendarDay,
              selectedDateStyle: TextStyles.calendarDay.copyWith(
                color: AppColors.textWhite,
              ),
              selectedPeriodMiddleTextStyle: TextStyles.calendarDay.copyWith(
                color: AppColors.textGrey,
              ),
              firstDayOfWeekIndex: 1,
              selectedSingleDateDecoration: BoxDecoration(
                color: AppColors.lime,
                borderRadius: BorderRadius.circular(12),
              ),
              selectedPeriodStartDecoration: BoxDecoration(
                color: AppColors.lime,
                borderRadius: BorderRadius.circular(12),
              ),
              selectedPeriodMiddleDecoration: BoxDecoration(
                color: Color(0xFFF8F8F8),
              ),
              selectedPeriodLastDecoration: BoxDecoration(
                color: AppColors.lime,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            eventDecorationBuilder: buildEventDecoration,
            onChanged: _updateSelectedPeriod,
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: _selectCustomPeriod,
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              foregroundColor: WidgetStatePropertyAll(AppColors.white),
              backgroundColor: WidgetStatePropertyAll(AppColors.lime),
            ),
            child: Text('Выбрать'),
          ),
        ],
      ),
    );
  }
}
