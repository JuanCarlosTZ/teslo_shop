import 'package:teslo_shop/feature/auth/domain/domains.dart';

abstract class AuthDatasource {
  Future<User> loginUser({required String email, required String password});

  Future<User> registerUser({
    required String username,
    required String email,
    required String password,
  });

  Future<User> checkAuth({required String token});
}
