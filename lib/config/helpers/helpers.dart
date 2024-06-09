import 'package:flutter/material.dart';

double forceTopPadding(
    {required BuildContext context, required double padding}) {
  final double viewTopPadding = MediaQuery.of(context).viewPadding.top;
  double newTopPadding = (viewTopPadding - padding) * -1;
  newTopPadding = (newTopPadding < 0) ? 0 : newTopPadding;
  return newTopPadding;
}

bool validateEmail(String value) {
  const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  final regex = RegExp(pattern);

  return regex.hasMatch(value);
}

bool containsUppercase(String value) => RegExp(r'[A-Z]').hasMatch(value);
bool containsLowercase(String value) => RegExp(r'[a-z]').hasMatch(value);
bool containsNumber(String value) => RegExp(r'\d').hasMatch(value);
