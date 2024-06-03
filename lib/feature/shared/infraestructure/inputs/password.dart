import 'package:formz/formz.dart';

enum PasswordError { required, lengthMin, uppercase, lowercase, number }

class Password extends FormzInput<String, PasswordError?> {
  final bool isRequired;
  final bool hardError;
  static int lengthMin = 6;
  static int lengthMax = 100;

  const Password.pure(
    super.value, {
    this.isRequired = false,
    this.hardError = false,
  }) : super.pure();
  const Password.dirty(
    super.value, {
    this.isRequired = false,
    this.hardError = false,
  }) : super.dirty();

  @override
  PasswordError? validator(String value) {
    if (value.isEmpty && !isRequired) return null;
    if (value.isEmpty && isRequired) return PasswordError.required;
    if (!hardError) return null;
    if (value.length <= lengthMin) return PasswordError.lengthMin;
    if (!containsLowercase(value)) return PasswordError.lowercase;
    if (!containsUppercase(value)) return PasswordError.uppercase;
    if (!containsNumber(value)) return PasswordError.number;
    return null;
  }

  String? passwordError() {
    if (isPure) return null;

    if (error == null) return null;
    if (error == PasswordError.required) return 'Required password';

    if (error == PasswordError.lengthMin) {
      return 'Password must be more than $lengthMin';
    }

    if (error == PasswordError.lowercase) {
      return 'Password must contain lowercase';
    }

    if (error == PasswordError.uppercase) {
      return 'Password must contain uppercase';
    }

    if (error == PasswordError.number) {
      return 'Password must contain number';
    }

    return null;
  }

  Password copyWith(
    String? value, {
    bool? isRequired,
    bool? hardError,
  }) {
    return Password.dirty(
      value ?? this.value,
      isRequired: isRequired ?? this.isRequired,
      hardError: hardError ?? this.hardError,
    );
  }
}

bool containsUppercase(String value) => RegExp(r'[A-Z]').hasMatch(value);
bool containsLowercase(String value) => RegExp(r'[a-z]').hasMatch(value);
bool containsNumber(String value) => RegExp(r'\d').hasMatch(value);
