import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teslo_shop/config/config.dart';

class Environment {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  static String get apiUrl => dotenv.env['API_URL'] ?? '';
  static String get contentType => dotenv.env['CONTENT_TYPE'] ?? '';
  static String get accept => dotenv.env['ACCEPT'] ?? '';
  static String get apiProductImageUrl =>
      '$apiUrl${PathParameter.fileProductPath}';
}
