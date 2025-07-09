import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tms/src/common/constants/color_constant.dart';
import 'package:tms/src/common/constants/text_styles.dart';
import 'package:tms/src/common/dependencies/injection_container.dart';
import 'package:tms/src/common/widgets/modal_bottom_sheet.dart';
import 'package:tms/src/screens/attendance/cubit/select_period_cubit.dart';
import 'package:tms/src/screens/attendance/widgets/period_picker.dart';

class PeriodPickerButton extends StatefulWidget {
  const PeriodPickerButton({super.key});

  @override
  State<PeriodPickerButton> createState() => _PeriodPickerButtonState();
}

class _PeriodPickerButtonState extends State<PeriodPickerButton> {
  bool periodSelected = false;
  DateFormat formatter = DateFormat('d MMM y', 'ru');
  late SelectPeriodCubit cubit;

  @override
  void initState() {
    cubit = context.read<SelectPeriodCubit>();
    cubit.getInitialData();
    super.initState();
  }

  void openFilters() {
    showStyledModalBottomSheet(
      context,
      'Фильтр',
      BlocProvider<SelectPeriodCubit>.value(
        value: getIt(),
        child: PeriodPicker(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openFilters,
      child: Container(
        height: 44,
        padding: EdgeInsets.only(left: 16, right: 12, top: 11, bottom: 13),
        decoration: BoxDecoration(
          color: AppColors.controlBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            BlocBuilder<SelectPeriodCubit, SelectPeriodState>(
              builder: (context, state) {
                periodSelected = cubit.from != null && cubit.to != null;
                return Text(
                  periodSelected
                      ? '${formatter.format(cubit.from!)} - ${formatter.format(cubit.to!)}'
                      : 'Выберите период',
                  style: TextStyles.bodySmall,
                );
              },
            ),
            Spacer(),
            SvgPicture.asset(
              'assets/icons/calendar-icon.svg',
              height: 20,
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
