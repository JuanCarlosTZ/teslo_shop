import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/feature/product/presentation/providers/products_repository_provider.dart';
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

  Future<void> loadProduct() async {
    if (state.id == 'new') return;

    final product = await loadProductCallback(state.id);

    state = state.copyWith(
      product: product,
      isLoading: false,
    );
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

  ProductState({
    this.id = '',
    this.product,
    this.isLoading = true,
    this.isPosting = false,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isPosting,
  }) {
    return ProductState(
      id: id ?? this.id,
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      isPosting: isPosting ?? this.isPosting,
    );
  }
}
