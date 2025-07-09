import 'package:tms/src/common/constants/color_constant.dart';
import 'package:flutter/material.dart';

class TextStyles {
  static const TextStyle head = TextStyle(
    fontFamily: 'SF Pro',
    color: AppColors.textBlack,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  static TextStyle bodyMedium = TextStyle(
    fontFamily: 'SF Pro',
    color: AppColors.textBlack,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static TextStyle bodySmall = TextStyle(
    fontFamily: 'SF Pro',
    color: AppColors.textGrey,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static TextStyle calendarDay = TextStyle(
    fontFamily: 'SF Pro',
    color: AppColors.textBlack,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
  static TextStyle descr = TextStyle(
    fontFamily: 'SF Pro',
    color: AppColors.textBlack,
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );
  static TextStyle descrSmall = TextStyle(
    fontFamily: 'SF Pro',
    color: AppColors.textBlack,
    fontSize: 10,
    fontWeight: FontWeight.w300,
  );
}
