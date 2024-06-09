class WrongCredentials implements Exception {}

class InvalidToken implements Exception {}

class ConnectionTimeout implements Exception {}

class ConextionError implements Exception {}

class CustomError implements Exception {
  final String message;
  final bool logRequired;

  CustomError({
    required this.message,
    required this.logRequired,
  });
}

class CustomErrorImpl implements Exception {
  final String message;
  final bool logRequired;

  CustomErrorImpl({required this.message, required this.logRequired});
}
