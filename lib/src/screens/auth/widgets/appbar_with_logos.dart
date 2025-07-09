import 'package:flutter/material.dart';

class AppbarWithLogos extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWithLogos({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      title: Image.asset('assets/icons/nls-logo.png', width: 144, height: 32),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Image.asset(
            'assets/icons/meganet-logo.png',
            width: 106,
            height: 32,
          ),
        ),
      ],
    );
  }
}
