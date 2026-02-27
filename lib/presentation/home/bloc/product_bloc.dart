import 'package:task28_02/app_export.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc(this._productRepository) : super(const ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<ProductState> emit,
  ) async {
    // Only show full loading if not already loaded
    if (state is! ProductLoaded) {
      emit(const ProductLoading());
    }
    await _loadProducts(event.category, emit);
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    await _loadProducts(event.category, emit);
  }

  Future<void> _loadProducts(
    String? category,
    Emitter<ProductState> emit,
  ) async {
    try {
      final products =
          await _productRepository.fetchProducts(category: category);
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(
        message: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}
