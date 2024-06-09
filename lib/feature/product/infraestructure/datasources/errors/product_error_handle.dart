import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/feature/auth/infraestructure/infraestructures.dart';

class ProductErrorHandle {
  static Future<T> handleDioError<T>(Future<T> Function() request) async {
    if (!await NetworkService.isInternetConnected()) {
      throw CustomError(
        message: 'Sin conexión de internet',
        logRequired: false,
      );
    }
    try {
      return await request();
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw e as Exception;
    }
  }

  static Exception handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError) {
      return ConextionError();
    }

    if (e.type == DioExceptionType.connectionTimeout) {
      return ConnectionTimeout();
    }

    if (e.response?.statusCode == 401) {
      return WrongCredentials();
    }

    if (e.response?.statusCode == 400) {
      const message = 'El título del producto ya existe';
      throw CustomError(
        message: message,
        logRequired: false,
      );
    }

    return Exception(e);
  }

  static String getErrorMessage(Exception e) {
    if (e is WrongCredentials) {
      return 'Credenciales inválidas';
    } else if (e is ConnectionTimeout) {
      return 'Tiempo de conexión agotado. Verifique su conexión a internet.';
    } else if (e is ConextionError) {
      return 'Error de conexión';
    } else if (e is CustomError) {
      return e.message;
    } else if (e is InvalidToken) {
      return 'Token inválido. Por favor, inicie sesión nuevamente.';
    } else {
      return 'Error inesperado';
    }
  }
}
