import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/feature/auth/auth.dart';
import 'package:teslo_shop/feature/shared/infraestructure/inputs/confirm_password.dart';
import 'package:teslo_shop/feature/shared/shared.dart';

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
  (ref) {
    final registerUserCallback =
        ref.watch(authUserProvider.notifier).registerUser;
    return RegisterFormNotifier(registerUserCallback: registerUserCallback);
  },
);

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Future<void> Function({
    required String email,
    required String password,
    required String username,
  }) registerUserCallback;
  RegisterFormNotifier({required this.registerUserCallback})
      : super(RegisterFormState());

  void onUsernameChange(String value) {
    final newState = state.copyWith(username: state.username.copyWith(value));
    state = newState;
  }

  void onEmailChange(String value) {
    final newState = state.copyWith(email: state.email.copyWith(value));
    state = newState;
  }

  void onPasswordChange(String value) {
    final confirmPassword = state.confirmPassword.copyWith(
      null,
      password: value,
    );

    final newState = state.copyWith(
      password: state.password.copyWith(value),
      confirmPassword: confirmPassword,
    );

    state = newState;
  }

  void onConfirmPasswordChange(String value) {
    final newState =
        state.copyWith(confirmPassword: state.confirmPassword.copyWith(value));
    state = newState;
  }

  void onSubmitted() {
    bool isValid = Formz.validate([
      state.username,
      state.email,
      state.password,
      state.confirmPassword,
    ]);

    final newState = state.copyWith(
      username: state.username.copyWith(null),
      email: state.email.copyWith(null),
      password: state.password.copyWith(null),
      confirmPassword: state.confirmPassword.copyWith(null),
      isValid: isValid,
      isPosted: true,
    );
    state = newState;

    registerUserCallback(
      username: state.username.value,
      email: state.email.value,
      password: state.password.value,
    );
  }
}

class RegisterFormState {
  final Username username;
  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;
  final bool isPosting;
  final bool isPosted;
  final bool isValid;

  RegisterFormState({
    this.username = const Username.pure('', isRequired: true),
    this.email = const Email.pure('', isRequired: true, hardValidate: true),
    this.password =
        const Password.pure('', isRequired: true, hardValidate: true),
    this.confirmPassword =
        const ConfirmPassword.pure('', isRequired: true, password: ''),
    this.isPosting = false,
    this.isPosted = false,
    this.isValid = false,
  });

  RegisterFormState copyWith({
    Username? username,
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    bool? isPosting,
    bool? isPosted,
    bool? isValid,
  }) {
    return RegisterFormState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPosting: isPosting ?? this.isPosting,
      isPosted: isPosted ?? this.isPosted,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  String toString() {
    return """
      Username: $username,
      Email: $email,
      Password: $password,
      ConfirmPassword: $confirmPassword,
      isPosting: $isPosting,
      isPosted: $isPosted,
      isValid: $isValid,
    """;
  }
}
