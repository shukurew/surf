import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tms/src/common/dependencies/nv_dio.dart';

class MockNvDio extends Mock implements NvDio {}

class MockDio extends Mock implements Dio {}
