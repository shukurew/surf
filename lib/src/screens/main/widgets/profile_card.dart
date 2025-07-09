import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String userName;
  final String initials;

  const ProfileCard({
    super.key,
    required this.userName,
    required this.initials,
  });

  static const _borderRadius = BorderRadius.all(Radius.circular(16));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/hubert.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: _borderRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Твоя визитная карточка',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontFamily: "SF-Pro",
                  ),
                ),
                Text(
                  'Привет, $userName',
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
          CircleAvatar(
            backgroundColor: Colors.white24,
            child: Text(
              initials,
              style: const TextStyle(color: Colors.white, fontFamily: "SF-Pro"),
            ),
          ),
        ],
      ),
    );
  }
}
