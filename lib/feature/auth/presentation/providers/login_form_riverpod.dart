import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:teslo_shop/feature/auth/auth.dart';
import 'package:teslo_shop/feature/shared/shared.dart';

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>(
  (ref) {
    final loginCallback = ref.watch(authUserProvider.notifier).loginUser;
    return LoginFormNotifier(loginCallback: loginCallback);
  },
);

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function({
    required String email,
    required String password,
  }) loginCallback;
  LoginFormNotifier({required this.loginCallback}) : super(LoginFormState());

  void onEmailChange(String value) {
    final newState = state.copyWith(email: state.email.copyWith(value: value));
    state = newState;
  }

  void onPasswordChange(String value) {
    final newState =
        state.copyWith(password: state.password.copyWith(value: value));
    state = newState;
  }

  void onSubmitted() async {
    bool isValid = Formz.validate([
      state.email,
      state.password,
    ]);

    final newState = state.copyWith(
      email: state.email.copyWith(),
      password: state.password.copyWith(),
      isValid: isValid,
      isPosted: true,
      isPosting: true,
    );

    state = newState;

    await loginCallback(
      email: state.email.value,
      password: state.password.value,
    );

    state = state.copyWith(isPosting: false);
  }
}

class LoginFormState {
  final Email email;
  final Password password;
  final bool isPosting;
  final bool isPosted;
  final bool isValid;

  LoginFormState({
    this.email = const Email.pure('', isRequired: true),
    this.password = const Password.pure('', isRequired: true),
    this.isPosting = false,
    this.isPosted = false,
    this.isValid = false,
  });

  LoginFormState copyWith({
    Email? email,
    Password? password,
    bool? isPosting,
    bool? isPosted,
    bool? isValid,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPosting: isPosting ?? this.isPosting,
      isPosted: isPosted ?? this.isPosted,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  String toString() {
    return """
      Email: $email,
      Password: $password,
      isPosting: $isPosting,
      isPosted: $isPosted,
      isValid: $isValid,
    """;
  }
}
