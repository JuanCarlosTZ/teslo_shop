import 'package:teslo_shop/feature/auth/domain/domains.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
        id: json['id'] ?? '',
        username: json['fullName'] ?? '',
        email: json['email'] ?? '',
        roles: List<String>.from(json['roles'].map((role) => role)),
        token: json['token'] ?? '',
      );
}
