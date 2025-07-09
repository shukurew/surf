import 'package:dio/dio.dart';
import 'package:tms/src/common/dependencies/nv_dio.dart';

abstract class MainService {
  Future<Map<String, dynamic>> getUserStats(String dateFrom, String dateTo);
  Future<Map<String, dynamic>> getMainScreenDocuments();
}

class MainServiceImplement extends MainService {
  MainServiceImplement({required NvDio nvDio}) {
    dio = nvDio.dio;
  }
  late final Dio dio;

  @override
  Future<Map<String, dynamic>> getUserStats(
    String dateFrom,
    String dateTo,
  ) async {
    final response = await dio.get(
      '/v1/new/events/get-events-stat',
      queryParameters: {'date_from': dateFrom, 'date_to': dateTo},
    );

    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Неверный формат ответа');
    }
  }

  @override
  Future<Map<String, dynamic>> getMainScreenDocuments() async {
    final response = await dio.get('/v1/dictionary/one-c/document/types');

    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Неверный формат ответа');
    }
  }
}
