import 'package:flutter/material.dart';
import 'package:tms/src/common/constants/color_constant.dart';
import 'package:tms/src/common/constants/text_styles.dart';

class AttendanceHeadings extends StatelessWidget {
  const AttendanceHeadings({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            'Дата',
            style: TextStyles.bodySmall.copyWith(color: AppColors.blue),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Приход',
            style: TextStyles.bodySmall.copyWith(color: AppColors.blue),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Уход',
            style: TextStyles.bodySmall.copyWith(color: AppColors.blue),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
