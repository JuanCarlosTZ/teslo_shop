import 'package:formz/formz.dart';

enum SlugError { required, format }

class Slug extends FormzInput<String, SlugError?> {
  final bool isRequired;

  const Slug.pure(
    super.value, {
    this.isRequired = false,
  }) : super.pure();

  const Slug.dirty(
    super.value, {
    this.isRequired = false,
  }) : super.dirty();

  @override
  SlugError? validator(String value) {
    if (value.isEmpty && !isRequired) return null;
    if (value.isEmpty && isRequired) return SlugError.required;
    if (value.contains("'") || value.contains('"') || value.contains(' ')) {
      return SlugError.format;
    }
    return null;
  }

  String? slugError() {
    if (isPure) return null;

    if (error == null) return null;
    if (error == SlugError.required) return 'Slug requerido';
    if (error == SlugError.format) {
      return 'Slug no debe contener espacios en blanco';
    }

    return null;
  }

  Slug copyWith({
    String? value,
    bool? isRequired,
  }) {
    return Slug.dirty(
      value ?? this.value,
      isRequired: isRequired ?? this.isRequired,
    );
  }
}
