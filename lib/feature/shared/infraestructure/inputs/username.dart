import 'package:formz/formz.dart';

enum UsernameError { required, lengthMax, invalid }

class Username extends FormzInput<String, UsernameError?> {
  static int lengthMax = 100;
  final bool isRequired;

  const Username.pure(
    super.value, {
    this.isRequired = false,
  }) : super.pure();

  const Username.dirty(
    super.value, {
    this.isRequired = false,
  }) : super.dirty();

  @override
  UsernameError? validator(String value) {
    if (value.isEmpty && !isRequired) return null;
    if (value.isEmpty && isRequired) return UsernameError.required;
    if (value.length >= lengthMax) return UsernameError.lengthMax;
    return null;
  }

  String? usernameError() {
    if (isPure) return null;

    if (error == null) return null;
    if (error == UsernameError.required) return 'Required username';
    if (error == UsernameError.lengthMax) {
      return 'Username must be less than $lengthMax';
    }

    return null;
  }

  Username copyWith({
    String? value,
    bool? isRequired,
  }) {
    return Username.dirty(
      value ?? this.value,
      isRequired: isRequired ?? this.isRequired,
    );
  }
}
