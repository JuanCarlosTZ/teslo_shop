import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/feature/product/domain/datasources/products_datasource.dart';
import 'package:teslo_shop/feature/product/domain/entities/product.dart';
import 'package:teslo_shop/feature/product/infraestructure/mappers/products_mapper.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio db;
  final String accessToken;

  ProductsDatasourceImpl({required this.accessToken})
      : db = Dio(BaseOptions(
          baseUrl: Environment.apiUrl,
          contentType: Environment.contentType,
          headers: {
            'accept': Environment.accept,
            'authorization': 'Bearer $accessToken',
          },
        ));

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) async {
    final response = await db.get('/products/$id');
    final product = ProductsMapper.jsonProcuctToEntity(response.data);
    return product;
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    final response = await db.get('/products', queryParameters: {
      'limit': limit,
      'offset': offset,
    });

    final products =
        ProductsMapper.jsonProductsToEntities(List.from(response.data));
    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) async {
    final response = await db.get('/products/all/$term');
    final products = ProductsMapper.jsonProductsToEntities(response.data);
    return products;
  }
}
