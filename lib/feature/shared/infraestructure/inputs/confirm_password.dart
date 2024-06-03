import 'package:formz/formz.dart';

enum ConfirmPasswordError { required, noMatch }

class ConfirmPassword extends FormzInput<String, ConfirmPasswordError?> {
  final bool isRequired;
  final String password;

  const ConfirmPassword.pure(
    super.value, {
    required this.password,
    this.isRequired = false,
  }) : super.pure();
  const ConfirmPassword.dirty(
    super.value, {
    required this.password,
    this.isRequired = false,
  }) : super.dirty();

  @override
  ConfirmPasswordError? validator(String value) {
    if (value.isEmpty && !isRequired) return null;
    if (value.isEmpty && isRequired) return ConfirmPasswordError.required;
    if (value != password) return ConfirmPasswordError.noMatch;
    return null;
  }

  String? confirmPasswordError() {
    if (isPure) return null;

    if (error == null) return null;
    if (error == ConfirmPasswordError.required) return 'Required password';

    if (error == ConfirmPasswordError.noMatch) {
      return 'Confirm password doesn\'t';
    }

    return null;
  }

  ConfirmPassword copyWith(
    String? value, {
    String? password,
    bool? isRequired,
  }) {
    return ConfirmPassword.dirty(
      value ?? this.value,
      password: password ?? this.password,
      isRequired: isRequired ?? this.isRequired,
    );
  }
}

bool containsUppercase(String value) => RegExp(r'[A-Z]').hasMatch(value);
bool containsLowercase(String value) => RegExp(r'[a-z]').hasMatch(value);
bool containsNumber(String value) => RegExp(r'\d').hasMatch(value);
