import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/config/router/app_router.dart';

void main() async {
  await Environment.initialize();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    print(dotenv.env['API_URL']);

    return MaterialApp.router(
      theme: AppTheme.get(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
