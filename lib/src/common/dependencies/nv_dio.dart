import 'package:dio/dio.dart';
import 'package:tms/src/common/cubit/auth_cubit_out.dart';
import 'package:tms/src/common/dependencies/injection_container.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';

class NvDio {
  late String apiUrl = dotenv.env['API_URL'] ?? '';
  late Dio dio;

  Dio get instance => dio;

  set path(String path) {
    dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    )..interceptors.addAll([NvDioInterceptor()]);
  }

  NvDio() {
    apiUrl = dotenv.env['API_URL'] ?? '';
    path = '';
  }
}

class NvDioInterceptor extends Interceptor {
  Box tokensBox = Hive.box('tokens');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] =
        'Bearer ${tokensBox.get('access_token')}';
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    options.headers['App-Version'] = '1.0.1';
    options.headers['App-Nickname'] = 'kzmeganet';

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      if (!err.requestOptions.path.contains('login-erp')) {
        getIt<AuthCubitOut>().logOut();
      }
    } else if (err.response?.statusCode == 505) {}

    handler.next(err);
  }
}
