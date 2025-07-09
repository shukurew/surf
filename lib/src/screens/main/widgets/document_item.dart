import 'package:flutter/material.dart';

class DocumentItem extends StatelessWidget {
  final String title;
  final String date;

  const DocumentItem({super.key, required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(
        'assets/images/file-icon.png',
        width: 56,
        height: 56,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: "SF-Pro",
        ),
      ),
      subtitle: Text(
        date,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
          fontFamily: "SF-Pro",
        ),
      ),
      trailing: Image.asset(
        'assets/images/download.png',
        width: 18,
        height: 18,
      ),
    );
  }
}
