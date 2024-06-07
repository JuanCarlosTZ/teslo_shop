import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/feature/auth/auth.dart';
import 'package:teslo_shop/feature/product/products.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final accessToken = ref.watch(authUserProvider).user?.token ?? '';
  final datasource = ProductsDatasourceImpl(accessToken: accessToken);

  return ProductsRepositoryImpl(datasource: datasource);
});
