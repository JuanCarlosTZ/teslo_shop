class PathParameter {
  static const String product = 'product';
  static const String products = 'products';
  static const String checkAuth = 'check-auth';
  static const String login = 'login';
  static const String register = 'register';

  static const String withOutId = 'no-id';
  static const String productId = 'productId';
  static const String newProduct = 'new';

  static String get initialPath => checkAuthPath;
  static String get homePath => '/';

  static String get productsPath => '/$products';
  static String get checkAuthPath => '/$checkAuth';
  static String get loginPath => '/$login';
  static String get registerPath => '/$login/$register';

  static String get productPath => '$product/:$productId';
  static String get productPathByNew => '$productsPath/$product/$newProduct';
  static String productPathById(String thisProductId) {
    return '$productsPath/$product/$thisProductId';
  }

  static List<String> get logoutPaths => <String>[
        loginPath,
        registerPath,
      ];
}
