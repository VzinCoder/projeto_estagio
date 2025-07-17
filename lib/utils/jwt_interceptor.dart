import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtInterceptor extends Interceptor {
  final Dio dio;
  final FlutterSecureStorage storage;
  String? _refreshTokenFutureResult;
  Future<String>? _refreshTokenFuture;

  JwtInterceptor(this.dio) : storage = const FlutterSecureStorage();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['is_refresh_request'] == true) {
      handler.next(options);
      return;
    }

    final token = await storage.read(key: 'access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.requestOptions.extra['is_refresh_request'] == true) {
      if (err.response?.statusCode == 401) {
        await _clearTokens();
      }
      handler.next(err);
      return;
    }

    if (err.response?.statusCode == 401) {
      final originalRequest = err.requestOptions;

      try {
        final newToken = await _getOrRefreshToken();
        originalRequest.headers['Authorization'] = 'Bearer $newToken';

        final response = await dio.fetch(originalRequest);
        handler.resolve(response);
      } catch (e) {
        if (e is DioException && e.response?.statusCode == 401) {
          await _clearTokens();
        }
        handler.reject(err);
      }
      return;
    }

    handler.next(err);
  }

  Future<String> _getOrRefreshToken() async {
    if (_refreshTokenFuture != null) {
      return _refreshTokenFuture!;
    }

    _refreshTokenFuture = _refreshToken();
    try {
      _refreshTokenFutureResult = await _refreshTokenFuture;
      return _refreshTokenFutureResult!;
    } finally {
      _refreshTokenFuture = null;
    }
  }

  Future<String> _refreshToken() async {
    final refreshToken = await storage.read(key: 'refresh_token');
    if (refreshToken == null) {
      await _clearTokens();
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/token/refresh/'),
        error: 'Refresh token ausente. Usuário precisa logar novamente.',
        type: DioExceptionType.cancel,
      );
    }

    try {
      final response = await dio.post(
        'http://10.0.2.2:8000/auth/token/refresh/',
        data: {'refresh': refreshToken},
        options: Options(extra: {'is_refresh_request': true}),
      );

      if (response.statusCode == 200 && response.data['access'] != null) {
        final newAccessToken = response.data['access'].toString();
        await storage.write(key: 'access_token', value: newAccessToken);
        return newAccessToken;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Falha ao renovar o token. Status: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  Future<void> _clearTokens() async {
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'refresh_token');
    print('Tokens de autenticação limpos.');
  }
}
