import 'package:formz/formz.dart';

enum EmailError { required, lengthMax, invalid }

class Email extends FormzInput<String, EmailError?> {
  static int lengthMax = 100;
  final bool isRequired;
  final bool hardError;

  const Email.pure(
    super.value, {
    this.isRequired = false,
    this.hardError = false,
  }) : super.pure();

  const Email.dirty(
    super.value, {
    this.isRequired = false,
    this.hardError = false,
  }) : super.dirty();

  @override
  EmailError? validator(String value) {
    if (value.isEmpty && !isRequired) return null;
    if (value.isEmpty && isRequired && hardError) return EmailError.required;
    if (value.length >= lengthMax && hardError) return EmailError.lengthMax;
    if (!validateEmail(value)) return EmailError.invalid;
    return null;
  }

  String? emailError() {
    if (isPure) return null;

    if (error == null) return null;
    if (error == EmailError.required) return 'Required email';
    if (error == EmailError.lengthMax) {
      return 'Email mush be less than $lengthMax';
    }

    if (error == EmailError.invalid) return 'Invalid email';
    return null;
  }

  Email copyWith(
    String? value, {
    bool? isRequired,
    bool? hardError,
  }) {
    return Email.dirty(
      value ?? this.value,
      isRequired: isRequired ?? this.isRequired,
      hardError: hardError ?? this.hardError,
    );
  }
}

bool validateEmail(String value) {
  const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  final regex = RegExp(pattern);

  return regex.hasMatch(value);
}
