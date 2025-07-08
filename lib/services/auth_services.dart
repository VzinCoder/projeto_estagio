import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String _baseUrl = 'http://10.0.2.2:8000';
  final String _loginEndpoint = '/auth/token/';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Dio _loginDio = Dio();

  AuthService() {
    _loginDio.options.headers['Content-Type'] = 'application/json';
    print(
      'AuthService: Instância de Dio configurada com Content-Type: application/json',
    );
  }

  Future<bool> login(String username, String password) async {
    final url = '$_baseUrl$_loginEndpoint';

    try {
      final response = await _loginDio.post(
        url,
        data: {'username': username, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final accessToken = data['access'];
        final refreshToken = data['refresh'];

        if (accessToken != null && refreshToken != null) {
          await _secureStorage.write(key: 'access_token', value: accessToken);
          await _secureStorage.write(key: 'refresh_token', value: refreshToken);
          print('Tokens salvos com sucesso!');
          return true;
        } else {
          print(
            'Erro: Token "access" ou "refresh" não encontrados nas respostas!',
          );
          return false;
        }
      } else {
        print(
          'Erro no login (StatusCode ${response.statusCode}): ${response.data}',
        );
        return false;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print(
          'Erro Dio (response): ${e.response!.statusCode} - ${e.response!.data}',
        );
        if (e.response!.statusCode == 401) {
          print('Credenciais inválidas.');
        }
      } else {
        print('Erro Dio (sem response): $e - ${e.message}');
      }
      return false;
    } catch (e) {
      print('Erro inesperado ao fazer requisição de login: $e');
      return false;
    }
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
    print('Tokens removidos. Usuário deslogado!');
  }
}
