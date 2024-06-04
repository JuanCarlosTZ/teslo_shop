import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/feature/auth/domain/domains.dart';
import 'package:teslo_shop/feature/auth/infraestructure/infraestructures.dart';

final authUserProvider = StateNotifierProvider<AuthUserNotifier, AuthUserState>(
  (ref) {
    final repository = AuthRepositoryImpl();
    return AuthUserNotifier(repository: repository);
  },
);

class AuthUserNotifier extends StateNotifier<AuthUserState> {
  final AuthRepository repository;
  AuthUserNotifier({required this.repository}) : super(AuthUserState());

  void _setLogedUser(User user) {
    //TODO almanecer token fisicamente
    state = AuthUserState(
      status: AuthStatus.authorized,
      user: user,
      message: '',
    );
  }

  void _setLogoutUser(String message) {
    state = AuthUserState(
      status: AuthStatus.notAuthorized,
      user: null,
      message: message,
    );
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    await Future.delayed(Durations.long2);
    try {
      final user = await repository.loginUser(
        email: email,
        password: password,
      );

      _setLogedUser(user);
    } catch (e) {
      final errorMessage = AuthErrorHandle.getErrorMessage(e as Exception);
      _setLogoutUser(errorMessage);
    }
  }

  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await Future.delayed(Durations.long2);
      final user = await repository.registerUser(
        username: username,
        email: email,
        password: password,
      );

      _setLogedUser(user);
    } catch (e) {
      final errorMessage = AuthErrorHandle.getErrorMessage(e as Exception);
      _setLogoutUser(errorMessage);
    }
  }
}

enum AuthStatus { checking, authorized, notAuthorized }

class AuthUserState {
  final AuthStatus status;
  final User? user;
  final String message;

  AuthUserState({
    this.status = AuthStatus.notAuthorized,
    this.user,
    this.message = '',
  });

  AuthUserState copyWith(
    AuthStatus? status,
    User? user,
    String? message,
  ) {
    return AuthUserState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return """

status: $status,

message: $message,

user: ${user.toString()},

""";
  }
}
