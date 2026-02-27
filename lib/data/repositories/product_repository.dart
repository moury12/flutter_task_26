import 'package:task28_02/app_export.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts({String? category});
}

class ProductRepositoryImpl implements ProductRepository {
  final Dio _dio;

  ProductRepositoryImpl(this._dio);

  @override
  Future<List<Product>> fetchProducts({String? category}) async {
    try {
      final String endpoint = category != null
          ? '${AppConstants.productsByCategoryEndpoint}/$category'
          : AppConstants.productsEndpoint;

      final response = await _dio.get(endpoint);
      logger.d(response.data);
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
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
        return 'Server error (${e.response?.statusCode}). Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
