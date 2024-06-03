import 'package:go_router/go_router.dart';

import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/feature/product/product.dart';
import '../../feature/auth/auth.dart';

final appRouter = GoRouter(
  initialLocation: '/${PathParameter.login}',
  routes: [
    ///* Default Routes
    GoRoute(
      path: '/',
      redirect: (context, state) => '/${PathParameter.products}',
    ),

    ///* Auth Routes
    GoRoute(
      path: '/${PathParameter.login}',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/${PathParameter.register}',
      builder: (context, state) => const RegisterScreen(),
    ),

    ///* Product Routes
    GoRoute(
      path: '/${PathParameter.products}',
      builder: (context, state) => const ProductScreen(),
    ),
  ],
);
