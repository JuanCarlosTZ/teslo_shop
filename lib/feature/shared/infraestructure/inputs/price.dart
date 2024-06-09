import 'package:formz/formz.dart';

enum PriceError { required, invalid, format }

class Price extends FormzInput<String, PriceError?> {
  final bool isRequired;
  const Price.pure(
    super.value, {
    this.isRequired = false,
  }) : super.pure();

  const Price.dirty(
    super.value, {
    this.isRequired = false,
  }) : super.dirty();

  double? get valueParsed => double.tryParse(value);

  @override
  PriceError? validator(String value) {
    if (isPure) return null;

    if (value.isEmpty && isRequired) return PriceError.format;

    final valuePased = double.tryParse(value) ?? -1.0;

    if (valuePased == -1.0) return PriceError.format;
    if (valuePased < 0.0) return PriceError.invalid;

    return null;
  }

  String? priceError() {
    if (isPure) return null;

    if (error == null) return null;
    if (error == PriceError.required) return 'Precio requerido';
    if (error == PriceError.format) return 'Precio con formato incorrecto';
    if (error == PriceError.invalid) return 'Precio debe ser positivo';

    return null;
  }

  Price copyWith({
    String? value,
    bool? isRequired,
  }) {
    return Price.dirty(
      value ?? this.value,
      isRequired: isRequired ?? this.isRequired,
    );
  }
}
