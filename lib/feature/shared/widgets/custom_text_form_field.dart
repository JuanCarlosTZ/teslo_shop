import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  const CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    const border = OutlineInputBorder(
      borderSide: BorderSide.none,
    );

    const borderRadius = Radius.circular(15);
    final boxDecoration = BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: borderRadius,
            bottomLeft: borderRadius,
            bottomRight: borderRadius),
        boxShadow: [
          BoxShadow(
              color: colors.onSurface.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ]);

    final customLabel = Row(
      children: [
        Text(label!),
        Icon(Icons.star, color: Colors.red.shade700, size: 10)
      ],
    );

    return Container(
      // padding: const EdgeInsets.only(bottom: 0, top: 15),
      decoration: boxDecoration,
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onFieldSubmitted: onFieldSubmitted,
        style: const TextStyle(fontSize: 20, color: Colors.black54),
        decoration: InputDecoration(
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border,
          focusedErrorBorder: border.copyWith(borderSide: BorderSide.none),
          isDense: true,
          label: label != null ? customLabel : null,
          hintText: hint,
          errorText: errorMessage,
          focusColor: colors.primary,
          // icon: Icon( Icons.supervised_user_circle_outlined, color: colors.primary, )
        ),
      ),
    );
  }
}
