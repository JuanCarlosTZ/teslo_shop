import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  static String apiUrl() => dotenv.env['API_URL'] ?? '';
  static String contentType() => dotenv.env['CONTENT_TYPE'] ?? '';
  static String accept() => dotenv.env['ACCEPT'] ?? '';
}
