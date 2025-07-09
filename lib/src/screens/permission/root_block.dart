import 'package:flutter/material.dart';

class RootBlock extends StatelessWidget {
  const RootBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Выключите режим разработчика и перезагрузите устройство'),
        ],
      ),
    );
  }
}
