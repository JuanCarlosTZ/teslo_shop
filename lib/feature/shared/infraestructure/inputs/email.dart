import 'package:formz/formz.dart';
import 'package:teslo_shop/config/config.dart';

enum EmailError { required, lengthMax, invalid }

class Email extends FormzInput<String, EmailError?> {
  static int lengthMax = 100;
  final bool isRequired;
  final bool hardValidate;

  const Email.pure(
    super.value, {
    this.isRequired = false,
    this.hardValidate = false,
  }) : super.pure();

  const Email.dirty(
    super.value, {
    this.isRequired = false,
    this.hardValidate = false,
  }) : super.dirty();

  @override
  EmailError? validator(String value) {
    if (value.isEmpty && !isRequired) return null;
    if (value.isEmpty && isRequired && hardValidate) return EmailError.required;
    if (value.length >= lengthMax && hardValidate) return EmailError.lengthMax;
    if (!validateEmail(value)) return EmailError.invalid;
    return null;
  }

  String? emailError() {
    if (isPure) return null;

    if (error == null) return null;
    if (error == EmailError.required) return 'Required email';
    if (error == EmailError.lengthMax) {
      return 'Email must be less than $lengthMax';
    }

    if (error == EmailError.invalid) return 'Invalid email';
    return null;
  }

  Email copyWith({
    String? value,
    bool? isRequired,
    bool? hardValidate,
  }) {
    return Email.dirty(
      value ?? this.value,
      isRequired: isRequired ?? this.isRequired,
      hardValidate: hardValidate ?? this.hardValidate,
    );
  }
}
