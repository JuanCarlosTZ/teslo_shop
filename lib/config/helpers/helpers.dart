import 'package:flutter/material.dart';

double forceTopPadding(
    {required BuildContext context, required double padding}) {
  final double viewTopPadding = MediaQuery.of(context).viewPadding.top;
  double newTopPadding = (viewTopPadding - padding) * -1;
  newTopPadding = (newTopPadding < 0) ? 0 : newTopPadding;
  return newTopPadding;
}
