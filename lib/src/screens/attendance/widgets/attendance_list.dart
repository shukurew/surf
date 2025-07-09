import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tms/src/common/constants/color_constant.dart';
import 'package:tms/src/common/constants/text_styles.dart';
import 'package:tms/src/common/models/attendance/attendance_day.dart';

class AttendanceList extends StatelessWidget {
  AttendanceList({super.key, required this.days});

  final List<AttendanceDay> days;

  final DateFormat formatter = DateFormat('E, d MMM.yyyy \'год\'', 'ru_RU');

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: days.length,
        itemBuilder:
            (context, index) => Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      formatter.format(DateTime.parse(days[index].date)),
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.textBlack,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Builder(
                      builder: (context) {
                        if (days[index].isDayOff) {
                          return Text(
                            'Выходной',
                            style: TextStyles.bodySmall.copyWith(
                              color: AppColors.blue,
                            ),
                          );
                        } else {
                          Color timeColor;
                          switch (days[index].isStartOk) {
                            case true:
                              timeColor = AppColors.textGreen;
                            case false:
                              timeColor = AppColors.textRed;
                            case null:
                              timeColor = AppColors.textGrey;
                          }

                          return Text(
                            days[index].startTime ?? '--:--',
                            style: TextStyles.bodySmall.copyWith(
                              color: timeColor,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Builder(
                      builder: (context) {
                        Color timeColor;
                        switch (days[index].isEndOk) {
                          case true:
                            timeColor = AppColors.textGreen;
                          case false:
                            timeColor = AppColors.textRed;
                          case null:
                            timeColor = AppColors.textGrey;
                        }

                        return Text(
                          days[index].isDayOff
                              ? ''
                              : days[index].endTime ?? '--:--',
                          textAlign: TextAlign.end,
                          style: TextStyles.bodySmall.copyWith(
                            color: timeColor,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        separatorBuilder:
            (context, index) => Divider(height: 1, color: Color(0xFFE7E7E8)),
      ),
    );
  }
}
