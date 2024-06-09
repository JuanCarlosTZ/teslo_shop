import 'package:formz/formz.dart';

enum TitleError { required }

class Title extends FormzInput<String, TitleError?> {
  final bool isRequired;

  const Title.pure(
    super.value, {
    this.isRequired = false,
  }) : super.pure();

  const Title.dirty(
    super.value, {
    this.isRequired = false,
  }) : super.dirty();

  @override
  TitleError? validator(String value) {
    if (value.isEmpty && !isRequired) return null;
    if (value.isEmpty && isRequired) return TitleError.required;
    return null;
  }

  String? titleError() {
    if (isPure) return null;

    if (error == null) return null;
    if (error == TitleError.required) return 'Título requerido';

    return null;
  }

  Title copyWith({
    String? value,
    bool? isRequired,
  }) {
    return Title.dirty(
      value ?? this.value,
      isRequired: isRequired ?? this.isRequired,
    );
  }
}
