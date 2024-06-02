import 'package:flutter/material.dart';
import 'package:teslo_shop/config/router/app_router.dart';
import 'package:teslo_shop/config/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.get(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}