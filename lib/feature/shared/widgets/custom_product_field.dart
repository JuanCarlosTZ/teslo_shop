import 'package:flutter/material.dart';

class CustomProductField extends StatelessWidget {
  final bool isTopField; // La idea es que tenga bordes redondeados arriba
  final bool isBottomField; // La idea es que tenga bordes redondeados abajo
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final bool required;
  final TextInputType? keyboardType;
  final int maxLines;
  final String initialValue;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  const CustomProductField({
    super.key,
    this.isTopField = false,
    this.isBottomField = false,
    this.label,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.required = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.initialValue = '',
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(40));

    const borderRadius = Radius.circular(15);

    final customLabel = Row(
      children: [
        label != null ? Text(label!) : const SizedBox(),
        required
            ? Icon(Icons.star, color: Colors.red.shade700, size: 10)
            : const SizedBox(),
      ],
    );

    return Column(
      children: [
        Container(
          // padding: const EdgeInsets.only(bottom: 0, top: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: isTopField ? borderRadius : Radius.zero,
                topRight: isTopField ? borderRadius : Radius.zero,
                bottomLeft: isBottomField ? borderRadius : Radius.zero,
                bottomRight: isBottomField ? borderRadius : Radius.zero,
              ),
              boxShadow: [
                if (isBottomField)
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 5,
                      offset: const Offset(0, 3))
              ]),
          child: TextFormField(
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            validator: validator,
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLines: maxLines,
            initialValue: initialValue,
            decoration: InputDecoration(
              prefix: errorMessage == null ? null : const SizedBox(height: 24),
              errorText: errorMessage,

              contentPadding: EdgeInsets.only(
                left: 12,
                right: 12,
                top: errorMessage == null ? 12 : 10,
                bottom: errorMessage == null ? 12 : 0,
              ),

              floatingLabelBehavior: maxLines > 1
                  ? FloatingLabelBehavior.always
                  : FloatingLabelBehavior.auto,
              floatingLabelStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
              enabledBorder: border,
              focusedBorder: border,
              errorBorder: border.copyWith(
                  borderSide: const BorderSide(color: Colors.transparent)),
              focusedErrorBorder: border.copyWith(
                  borderSide: const BorderSide(color: Colors.transparent)),
              isDense: true,

              label: customLabel,
              hintText: hint,
              focusColor: colors.primary,
              // icon: Icon( Icons.supervised_user_circle_outlined, color: colors.primary, )
            ),
          ),
        ),
        if (!isBottomField && errorMessage != null)
          Container(height: 24, width: double.infinity, color: Colors.white),
      ],
    );
  }
}
