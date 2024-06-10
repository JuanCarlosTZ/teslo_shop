import 'package:teslo_shop/feature/product/domain/domains.dart';

abstract class ProductsRepository {
  Future<String> uploadFile(String path);

  Future<List<String>> uploadFiles(List<String> paths);

  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0});

  Future<Product> getProductById(String id);

  Future<List<Product>> searchProductByTerm(String term);

  Future<Product> createUpdateProduct(Map<String, dynamic> productLike);
}
