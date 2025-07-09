import 'package:flutter/material.dart';
import 'package:tms/src/common/constants/color_constant.dart';
import 'package:tms/src/common/constants/text_styles.dart';
import 'package:tms/src/screens/attendance/widgets/time_periods.dart';

class PeriodPickerOption extends StatelessWidget {
  const PeriodPickerOption({
    super.key,
    required this.type,
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  final TimePeriod type;
  final String label;
  final bool isSelected;
  final Function(TimePeriod timePeriod)? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap?.call(type),
      leading: Text(
        label,
        style: TextStyles.bodySmall.copyWith(
          fontSize: 16,
          color: AppColors.textBlack,
        ),
      ),
      trailing:
          type != TimePeriod.custom
              ? (isSelected ? Icon(Icons.check) : null)
              : Icon(Icons.arrow_forward_ios_rounded, size: 16),
    );
  }
}
