import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgNavIcon extends StatelessWidget {
  final String assetPath;
  final bool isActive;
  final String label;

  const SvgNavIcon({
    super.key,
    required this.assetPath,
    required this.isActive,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF68D168) : Colors.grey;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          assetPath,
          width: 32,
          height: 32,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: "SF-Pro",
          ),
        ),
      ],
    );
  }
}
