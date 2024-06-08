import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/feature/product/presentation/providers/products_repository_provider.dart';
import 'package:teslo_shop/feature/product/products.dart';

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return ProductsNotifier(productsRepository: productsRepository);
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;

  ProductsNotifier({required this.productsRepository})
      : super(ProductsState()) {
    loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final products = await productsRepository.getProductsByPage(
      limit: state.itemsByPage,
      offset: state.page * state.itemsByPage,
    );

    if (products.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      isRefreshing: false,
      page: state.page + 1,
      products:
          state.isRefreshing ? products : [...state.products, ...products],
    );
  }

  Future<void> refresh() async {
    if (state.isLoading) return;

    state = ProductsState(isRefreshing: true, products: state.products);

    await loadNextPage();
  }

  void updateProduct({required Product product}) {
    final products = state.products.map((productItem) {
      return (productItem.id == product.id) ? product : productItem;
    }).toList();

    state = state.copyWith(products: products);
  }
}

class ProductsState {
  final bool isLoading;
  final bool isRefreshing;
  final bool isLastPage;
  final int page;
  final int itemsByPage;
  final List<Product> products;

  ProductsState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLastPage = false,
    this.page = 0,
    this.itemsByPage = 10,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isLastPage,
    int? page,
    List<Product>? products,
  }) {
    return ProductsState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLastPage: isLastPage ?? this.isLastPage,
      page: page ?? this.page,
      products: products ?? this.products,
    );
  }
}
