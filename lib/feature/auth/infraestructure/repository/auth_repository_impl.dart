import 'package:teslo_shop/feature/auth/domain/domains.dart';
import 'package:teslo_shop/feature/auth/infraestructure/infraestructures.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({AuthDatasource? datasource})
      : datasource = datasource ?? AuthDatasourceImpl();

  @override
  Future<User> checkAuthUser({required String token}) async {
    return await datasource.checkAuth(token: token);
  }

  @override
  Future<User> loginUser({
    required String email,
    required String password,
  }) async {
    return await datasource.loginUser(
      email: email,
      password: password,
    );
  }

  @override
  Future<User> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    return await datasource.registerUser(
      username: username,
      email: email,
      password: password,
    );
  }
}
