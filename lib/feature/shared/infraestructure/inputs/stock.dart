import 'package:formz/formz.dart';

enum StockError { required, invalid, format }

class Stock extends FormzInput<String, StockError?> {
  final bool isRequired;
  const Stock.pure(
    super.value, {
    this.isRequired = false,
  }) : super.pure();

  const Stock.dirty(
    super.value, {
    this.isRequired = false,
  }) : super.dirty();

  int? get valueParsed => int.tryParse(value);

  @override
  StockError? validator(String value) {
    if (isPure) return null;

    if (value.isEmpty && isRequired) return StockError.format;

    final valuePased = int.tryParse(value) ?? -1;

    if (valuePased == -1) return StockError.format;
    if (valuePased < 0) return StockError.invalid;

    return null;
  }

  String? stockError() {
    if (isPure) return null;

    if (error == null) return null;
    if (error == StockError.required) return 'Existencia requerida';
    if (error == StockError.format) return 'Existencia con formato incorrecto';
    if (error == StockError.invalid) return 'Existencia debe ser positiva';

    return null;
  }

  Stock copyWith({
    String? value,
    bool? isRequired,
  }) {
    return Stock.dirty(
      value ?? this.value,
      isRequired: isRequired ?? this.isRequired,
    );
  }
}
