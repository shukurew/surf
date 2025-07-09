import 'package:flutter/material.dart';

class UtilityItem extends StatelessWidget {
  final String imagePath;
  final String label;

  const UtilityItem({super.key, required this.imagePath, required this.label});

  static const _borderRadius = BorderRadius.all(Radius.circular(20));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: _borderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 56, height: 56),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              fontFamily: "SF-Pro",
            ),
          ),
        ],
      ),
    );
  }
}
