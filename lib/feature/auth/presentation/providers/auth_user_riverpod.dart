import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/feature/auth/domain/domains.dart';
import 'package:teslo_shop/feature/auth/infraestructure/infraestructures.dart';
import 'package:teslo_shop/feature/shared/infraestructure/infraestructures.dart';

final authUserProvider = StateNotifierProvider<AuthUserNotifier, AuthUserState>(
  (ref) {
    final authRepository = AuthRepositoryImpl();
    final prefsRepository = KeyValuePreferenceRepositoryImpl();
    return AuthUserNotifier(
      authRepository: authRepository,
      prefsRepository: prefsRepository,
    );
  },
);

class AuthUserNotifier extends StateNotifier<AuthUserState> {
  final AuthRepository authRepository;
  final KeyValuePreferenceRepositoryImpl prefsRepository;
  AuthUserNotifier({
    required this.authRepository,
    required this.prefsRepository,
  }) : super(AuthUserState()) {
    _checkLoggedUser();
  }

  void _checkLoggedUser() async {
    await Future.delayed(Durations.long2);

    try {
      final token = await prefsRepository.getValue<String>('token');
      if (token == null || token.isEmpty) return setLogoutUser();

      await checkAuthUser(token: token);
    } catch (e) {
      setLogoutUser();
    }
  }

  void _setLoggedUser(User user) async {
    try {
      await prefsRepository.setKeyValue('token', user.token);
    } catch (e) {
      throw UnimplementedError(e.toString());
    }

    state = AuthUserState(
      status: AuthStatus.authorized,
      user: user,
      message: '',
    );
  }

  void setLogoutUser({String? message}) async {
    try {
      await prefsRepository.removeKey('token');
    } catch (e) {
      throw UnimplementedError(e.toString());
    }
    state = AuthUserState(
      status: AuthStatus.notAuthorized,
      user: null,
      message: message ?? '',
    );
  }

  Future<void> checkAuthUser({required String token}) async {
    await Future.delayed(Durations.long2);
    try {
      final user = await authRepository.checkAuthUser(token: token);

      _setLoggedUser(user);
    } catch (e) {
      final errorMessage = AuthErrorHandle.getErrorMessage(e as Exception);
      setLogoutUser(message: errorMessage);
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    await Future.delayed(Durations.long2);
    try {
      final user = await authRepository.loginUser(
        email: email,
        password: password,
      );

      _setLoggedUser(user);
    } catch (e) {
      final errorMessage = AuthErrorHandle.getErrorMessage(e as Exception);
      setLogoutUser(message: errorMessage);
    }
  }

  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await Future.delayed(Durations.long2);
      final user = await authRepository.registerUser(
        username: username,
        email: email,
        password: password,
      );

      _setLoggedUser(user);
    } catch (e) {
      final errorMessage = AuthErrorHandle.getErrorMessage(e as Exception);
      setLogoutUser(message: errorMessage);
    }
  }
}

enum AuthStatus { checking, authorized, notAuthorized }

class AuthUserState {
  final AuthStatus status;
  final User? user;
  final String message;

  AuthUserState({
    this.status = AuthStatus.checking,
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
