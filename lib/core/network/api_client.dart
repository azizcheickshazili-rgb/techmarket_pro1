import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_constants.dart';
import '../storage/secure_storage_service.dart';

/// Exception used internally to signal that a request failed
/// authentication and the caller should force a logout.
class UnauthorizedException implements Exception {
  const UnauthorizedException();
}

/// Configures a single [Dio] instance for the whole app: base URL,
/// timeouts, a bearer-token interceptor and (debug-only) logging.
class ApiClient {
  ApiClient({
    required SecureStorageService secureStorage,
    Dio? dio,
  })  : _secureStorage = secureStorage,
        dio = dio ?? Dio() {
    this.dio.options
      ..baseUrl = ApiConstants.baseUrl
      ..connectTimeout = ApiConstants.connectTimeout
      ..receiveTimeout = ApiConstants.receiveTimeout;

    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
          if (!options.extra.containsKey('skipAuth')) {
            final String? token = await _secureStorage.readAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          handler.next(error);
        },
      ),
    );

    assert(() {
      this.dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: false,
          requestBody: true,
          responseBody: false,
          error: true,
          compact: true,
        ),
      );
      return true;
    }());
  }

  final Dio dio;
  final SecureStorageService _secureStorage;
}
