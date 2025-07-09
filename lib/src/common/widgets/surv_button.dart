import 'package:flutter/material.dart';
import 'package:tms/src/common/constants/color_constant.dart';

class SurvButton extends StatelessWidget {
  const SurvButton({
    super.key,
    required this.label,
    this.color = AppColors.lime,
    this.textColor = AppColors.textWhite,
    this.onPressed,
  });

  final String label;
  final Color color;
  final Color textColor;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12),
        backgroundColor: color,
        foregroundColor: textColor,
        disabledBackgroundColor: Color(0xFFF2F1F0),
        disabledForegroundColor: Colors.white70,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'SF-Pro',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
