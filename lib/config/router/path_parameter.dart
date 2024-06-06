class PathParameter {
  static const products = 'products';
  static const checkAuth = 'check-auth';
  static const login = 'login';
  static const register = 'register';

  static String get initialPath => checkAuthPath;
  static String get homePath => '/';

  static String get productsPath => '/$products';
  static String get checkAuthPath => '/$checkAuth';
  static String get loginPath => '/$login';
  static String get registerPath => '/$login/$register';

  static List<String> get logoutPaths => <String>[
        loginPath,
        registerPath,
      ];
}
