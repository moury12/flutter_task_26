import 'package:task28_02/app_export.dart';

abstract class AuthRepository {
  Future<String> login(String username, String password);
  Future<User> fetchUser(int userId);
}

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post(
        AppConstants.loginEndpoint,
        data: {'username': username, 'password': password},
      );
      final token = response.data['token'] as String;
      logger.d(response.data);
      return token;
    } on DioException catch (e) {
      logger.e(e);
      throw Exception(_handleDioError(e));
    } catch (e) {
      logger.e(e);
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<User> fetchUser(int userId) async {
    try {
      final response = await _dio.get('${AppConstants.usersEndpoint}/$userId');
      logger.d(response.data);
      return User.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      logger.e(e);
      throw Exception(_handleDioError(e));
    } catch (e) {
      logger.e(e);
      throw Exception('An unexpected error occurred: $e');
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) return 'Invalid username or password.';
        return 'Server error ($statusCode). Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
