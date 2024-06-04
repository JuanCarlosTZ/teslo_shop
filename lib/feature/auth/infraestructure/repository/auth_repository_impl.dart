import 'package:teslo_shop/feature/auth/domain/domains.dart';
import 'package:teslo_shop/feature/auth/infraestructure/infraestructures.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({AuthDatasource? datasource})
      : datasource = datasource ?? AuthDatasourceImpl();

  @override
  Future<User> checkAuth({required String token}) async {
    // TODO: manejo de errores
    return await datasource.checkAuth(token: token);
  }

  @override
  Future<User> loginUser(
      {required String email, required String password}) async {
    // TODO: implement loginUser
    return await datasource.loginUser(email: email, password: password);
  }

  @override
  Future<User> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    // TODO: implement registerUser
    return await datasource.registerUser(
      username: username,
      email: email,
      password: password,
    );
  }
}
