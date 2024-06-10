import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/feature/product/products.dart';
import 'package:teslo_shop/feature/shared/shared.dart';

final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductFormState, String>((ref, productId) {
  final productNotifier = ref.watch(productProvider(productId).notifier);
  final product = ref.watch(productProvider(productId)).product;

  return ProductFormNotifier(
    productNotifier: productNotifier,
    product: product,
  );
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final ProductNotifier productNotifier;

  ProductFormNotifier({
    required this.productNotifier,
    Product? product,
  }) : super(ProductFormState()) {
    _initializeProductFormState(product);
  }

  void _initializeProductFormState(Product? product) async {
    if (product == null) return;

    final productPayload = ProductsMapper.productEntityToPayload(product);

    state = ProductFormState(
      productId: productPayload.productId ?? '',
      title: Title.pure(productPayload.title, isRequired: true),
      price: Price.pure(productPayload.price.toString()),
      description: productPayload.description,
      slug: Slug.pure(productPayload.slug, isRequired: true),
      stock: Stock.pure(productPayload.stock.toString()),
      sizes: productPayload.sizes,
      gender: productPayload.gender,
      tags: productPayload.tags,
      images: productPayload.images,
    );
  }

  void onTitleChange(String value) {
    state = state.copyWith(title: Title.dirty(value, isRequired: true));
  }

  void onPriceChange(String value) {
    state = state.copyWith(price: Price.dirty(value));
  }

  void onDescriptionChange(String value) {
    state = state.copyWith(description: value);
  }

  void onSlugChange(String value) {
    state = state.copyWith(slug: Slug.dirty(value, isRequired: true));
  }

  void onStockChange(String value) {
    state = state.copyWith(stock: Stock.dirty(value));
  }

  void onSizesChange(List<String> value) {
    state = state.copyWith(sizes: value);
  }

  void onGenderChange(String value) {
    state = state.copyWith(gender: value);
  }

  void onTagsChange(List<String> value) {
    state = state.copyWith(tags: value);
  }

  void onImagesChange(List<String> value) {
    state = state.copyWith(images: value);
  }

  void updateProductImage(String image) {
    state = state.copyWith(images: [...state.images, image]);
  }

  Future<bool> postProduct() async {
    if (!_validatePayload()) return false;

    final productPayload = _productPayload();
    final save =
        await productNotifier.postProduct(productPayload: productPayload);
    return save;
  }

  bool _validatePayload() {
    state = state.copyWith(
      title: state.title.copyWith(),
      price: state.price.copyWith(),
      slug: state.slug.copyWith(),
      stock: state.stock.copyWith(),
    );

    return isValidPayload();
  }

  bool isValidPayload() {
    final valid = Formz.validate([
      state.title,
      state.price,
      state.slug,
      state.stock,
    ]);
    return valid;
  }

  ProductPayload _productPayload() {
    return ProductPayload(
      productId: state.productId,
      title: state.title.value,
      price: state.price.valueParsed ?? 0,
      description: state.description,
      slug: state.slug.value,
      stock: state.stock.valueParsed ?? 0,
      sizes: state.sizes,
      gender: state.gender,
      tags: state.tags,
      images: state.images,
    );
  }
}

class ProductFormState {
  final String productId;
  final Title title;
  final Price price;
  final String description;
  final Slug slug;
  final Stock stock;
  final List<String> sizes;
  final String gender;
  final List<String> tags;
  final List<String> images;

  ProductFormState({
    this.productId = '',
    this.title = const Title.pure('', isRequired: true),
    this.price = const Price.pure('0.0'),
    this.description = '',
    this.slug = const Slug.pure('', isRequired: true),
    this.stock = const Stock.pure('0'),
    this.sizes = const ['L'],
    this.gender = 'men',
    this.tags = const [],
    this.images = const [],
  });

  ProductFormState copyWith({
    bool? isLoading,
    bool? isPosting,
    String? productId,
    Title? title,
    Price? price,
    String? description,
    Slug? slug,
    Stock? stock,
    List<String>? sizes,
    String? gender,
    List<String>? tags,
    List<String>? images,
  }) {
    return ProductFormState(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      slug: slug ?? this.slug,
      stock: stock ?? this.stock,
      sizes: sizes ?? this.sizes,
      gender: gender ?? this.gender,
      tags: tags ?? this.tags,
      images: images ?? this.images,
    );
  }
}
