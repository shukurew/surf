import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  await Hive.openBox('tokens');
  await Hive.openBox('user');
}
