import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String backgroundImage;
  final String iconPath;
  final String title;
  final String subtitle;

  const FeatureCard({
    super.key,
    required this.backgroundImage,
    required this.iconPath,
    required this.title,
    required this.subtitle,
  });

  static const _borderRadius = BorderRadius.all(Radius.circular(16));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
        borderRadius: _borderRadius,
      ),
      child: ClipRRect(
        borderRadius: _borderRadius,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        fontFamily: "SF-Pro",
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "SF-Pro",
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(iconPath, width: 40, height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
