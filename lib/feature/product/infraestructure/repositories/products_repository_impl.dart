import 'package:teslo_shop/feature/product/domain/datasources/products_datasource.dart';
import 'package:teslo_shop/feature/product/domain/entities/product.dart';
import 'package:teslo_shop/feature/product/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsDatasource _datasource;

  ProductsRepositoryImpl({required ProductsDatasource datasource})
      : _datasource = datasource;

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    return await _datasource.createUpdateProduct(productLike);
  }

  @override
  Future<Product> getProductById(String id) async {
    return await _datasource.getProductById(id);
  }

  @override
  Future<List<Product>> getProductsByPage({
    int limit = 10,
    int offset = 0,
  }) async {
    return await _datasource.getProductsByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) async {
    return await _datasource.searchProductByTerm(term);
  }
}
