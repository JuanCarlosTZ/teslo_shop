import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/config/router/auth_change_notifier_riverpod.dart';
import 'package:teslo_shop/feature/product/product.dart';
import '../../feature/auth/auth.dart';

final appRouteProvider = StateProvider((ref) {
  final authChangeNotifier = ref.read(authChangeNotifierProvider.notifier);

  return GoRouter(
    initialLocation: '/${PathParameter.checkAuth}',
    refreshListenable: authChangeNotifier,
    routes: [
      ///* Default Routes
      GoRoute(
        path: PathParameter.homePath,
        redirect: (context, state) => PathParameter.productsPath,
      ),

      ///* Auth Routes
      GoRoute(
        path: PathParameter.loginPath,
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: PathParameter.register,
            builder: (context, state) => const RegisterScreen(),
          ),
        ],
      ),

      ///* Checking Auth Routes
      GoRoute(
        path: PathParameter.checkAuthPath,
        builder: (context, state) => const CheckAuthScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: PathParameter.productsPath,
        builder: (context, state) => const ProductScreen(),
      ),
    ],

    ///* Routes protection
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final status = authChangeNotifier.authStatus;

      print(isGoingTo);
      print(status);

      switch (status) {
        case AuthStatus.checking:
          {
            if (isGoingTo == PathParameter.checkAuthPath) return null;
          }

        case AuthStatus.notAuthorized:
          {
            if (!PathParameter.logoutPaths.contains(isGoingTo)) {
              return PathParameter.loginPath;
            }
          }

        case AuthStatus.authorized:
          if (isGoingTo == PathParameter.checkAuthPath ||
              PathParameter.logoutPaths.contains(isGoingTo)) {
            return PathParameter.homePath;
          }
      }

      return null;
    },
  );
});
