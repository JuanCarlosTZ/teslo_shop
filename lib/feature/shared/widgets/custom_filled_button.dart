import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color? buttonColor;
  final bool expanded;

  const CustomFilledButton({
    super.key,
    this.onPressed,
    required this.text,
    this.buttonColor,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(10);
    final filledButton = FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: buttonColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: radius,
            bottomRight: radius,
            topLeft: radius,
          )),
        ),
        onPressed: onPressed,
        child: Text(text));
    return expanded
        ? SizedBox(
            width: double.infinity,
            height: 60,
            child: filledButton,
          )
        : filledButton;
  }
}
