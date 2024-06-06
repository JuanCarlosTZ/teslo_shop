import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/feature/auth/domain/domains.dart';
import 'package:teslo_shop/feature/auth/infraestructure/infraestructures.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl(),
    contentType: Environment.contentType(),
  ));

  @override
  Future<User> checkAuth({required String token}) async {
    return AuthErrorHandle.handleDioError(
      () async {
        final response = await dio.get(
          '/auth/check-status',
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }),
        );

        final user = UserMapper.userJsonToEntity(response.data);
        return user;
      },
    );
  }

  @override
  Future<User> loginUser({
    required String email,
    required String password,
  }) async {
    return AuthErrorHandle.handleDioError(
      () async {
        final response = await dio.post('/auth/login', data: {
          'email': email,
          'password': password,
        });

        final user = UserMapper.userJsonToEntity(response.data);
        return user;
      },
    );
  }

  @override
  Future<User> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    return AuthErrorHandle.handleDioError(
      () async {
        final response = await dio.post('/auth/register', data: {
          'fullName': username,
          'email': email,
          'password': password,
        });

        final user = UserMapper.userJsonToEntity(response.data);
        return user;
      },
    );
  }
}
