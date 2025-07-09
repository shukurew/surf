import 'package:flutter/material.dart';
import 'package:tms/src/common/router/routing_constant.dart';

class AttendanceCard extends StatelessWidget {
  final String month;
  final int onTimeCount;
  final int lateCount;

  const AttendanceCard({
    super.key,
    required this.month,
    required this.onTimeCount,
    required this.lateCount,
  });

  static const _borderRadius = BorderRadius.all(Radius.circular(16));
  static const _horizontalPadding = 16.0;
  static const _verticalPadding = 20.0;

  VoidCallback goToAttendanceScreen(BuildContext context) => () {
    Navigator.pushNamed(context, RoutingConst.attendance);
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: goToAttendanceScreen(context),
      child: Container(
        height: 132,
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          image: const DecorationImage(
            image: AssetImage('assets/images/attendance_back.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRRect(
          borderRadius: _borderRadius,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/images/alarm.png',
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                  vertical: _verticalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'за $month',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: "SF-Pro",
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Посещаемость',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "SF-Pro",
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildCountBadge(
                          '$onTimeCount вовремя',
                          Color(0xFF02D15C),
                        ),
                        const SizedBox(width: 6),
                        _buildCountBadge(
                          '$lateCount опозданий',
                          Color(0xFFFFB020),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountBadge(String text, Color bgColor) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        fontFamily: "SF-Pro",
      ),
    ),
  );
}
