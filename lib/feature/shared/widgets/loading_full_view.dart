import 'package:flutter/material.dart';

class LoadingFullView extends StatelessWidget {
  const LoadingFullView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
