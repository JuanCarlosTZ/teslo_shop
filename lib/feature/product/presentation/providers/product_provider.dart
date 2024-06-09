import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/config/router/path_parameter.dart';
import 'package:teslo_shop/feature/product/infraestructure/datasources/errors/product_error_handle.dart';
import 'package:teslo_shop/feature/product/products.dart';

final productProvider = StateNotifierProvider.autoDispose
    .family<ProductNotifier, ProductState, String>((ref, productId) {
  final loadProductCallback =
      ref.watch(productsRepositoryProvider).getProductById;
  final postProductCallback =
      ref.watch(productsRepositoryProvider).createUpdateProduct;

  final onProductUpdated = ref.read(productsProvider.notifier).updateProduct;

  return ProductNotifier(
    productId: productId,
    postProductCallback: postProductCallback,
    loadProductCallback: loadProductCallback,
    onProductUpdated: onProductUpdated,
  );
});

class ProductNotifier extends StateNotifier<ProductState> {
  final Future<Product> Function(
    Map<String, dynamic> productLike,
  ) postProductCallback;

  final Future<Product> Function(String productId) loadProductCallback;

  final void Function({required Product product})? onProductUpdated;

  ProductNotifier({
    required String productId,
    required this.postProductCallback,
    required this.loadProductCallback,
    this.onProductUpdated,
  }) : super(ProductState(id: productId)) {
    ///*inicializar producto
    loadProduct();
  }

  Future<Product?> loadProduct() async {
    try {
      if (state.id == PathParameter.newProduct) return null;

      state = state.copyWith(
        isLoading: true,
      );

      final product = await loadProductCallback(state.id);

      state = state.copyWith(
        product: product,
        isLoading: false,
      );
      return product;
    } catch (e) {
      final errorMessage = ProductErrorHandle.getErrorMessage(e as Exception);
      state = state.copyWith(notification: errorMessage);
      state = state.copyWith();
      return null;
    }
  }

  Future<bool> postProduct({required ProductPayload productPayload}) async {
    try {
      state = state.copyWith(isPosting: true);

      final productLike = ProductsMapper.productPayloadToJson(productPayload);
      final product = await postProductCallback(productLike);

      if (onProductUpdated != null) onProductUpdated!(product: product);

      state = state.copyWith(
        id: product.id,
        product: product,
        isPosting: false,
      );
    } catch (e) {
      final errorMessage = ProductErrorHandle.getErrorMessage(e as Exception);
      state = state.copyWith(notification: errorMessage);
      state = state.copyWith(isPosting: false);
      return false;
    }
    return true;
  }
}

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isPosting;
  final String? notification;

  ProductState({
    this.id = '',
    this.product,
    this.isLoading = false,
    this.isPosting = false,
    this.notification,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isPosting,
    String? notification,
  }) {
    return ProductState(
      id: id ?? this.id,
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      isPosting: isPosting ?? this.isPosting,
      notification: notification,
    );
  }
}
