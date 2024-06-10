import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/feature/product/domain/datasources/products_datasource.dart';
import 'package:teslo_shop/feature/product/domain/entities/product.dart';
import 'package:teslo_shop/feature/product/infraestructure/datasources/errors/product_error_handle.dart';
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
  Future<String> uploadFile(String path) async {
    return await ProductErrorHandle.handleDioError(() async {
      final fileName = path.split('/').last;
      final FormData data = FormData.fromMap(
          {'file': MultipartFile.fromFileSync(path, filename: fileName)});

      final response = await db.post(PathParameter.fileProductPath, data: data);

      final image = response.data['image'];
      return image;
    });
  }

  @override
  Future<List<String>> uploadFiles(List<String> paths) async {
    final imagesToUpload = paths.where((image) => image.contains('/')).toList();
    final imagesUploaded =
        paths.where((image) => !image.contains('/')).toList();

    if (imagesToUpload.isEmpty) return paths;

    final newFilesUplaoded =
        await Future.wait(imagesToUpload.map(uploadFile).toList());

    return [...imagesUploaded, ...newFilesUplaoded];
  }

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    return await ProductErrorHandle.handleDioError(() async {
      final String? productId = productLike['id'];
      final String method =
          (productId == null || productId.isEmpty) ? 'POST' : 'PATCH';

      final String url = (productId == null || productId.isEmpty)
          ? '/products'
          : '/products/$productId';

      productLike.remove('id');
      productLike.remove('user');

      final images = List<String>.from(productLike['images']);
      if (images.isNotEmpty) {
        productLike['images'] = await uploadFiles(images);
      }

      final response = await db.request(url,
          data: productLike, options: Options(method: method));

      final product = ProductsMapper.jsonProcuctToEntity(response.data);
      return product;
    });
  }

  @override
  Future<Product> getProductById(String id) async {
    return await ProductErrorHandle.handleDioError(() async {
      final response = await db.get('/products/$id');
      final product = ProductsMapper.jsonProcuctToEntity(response.data);
      return product;
    });
  }

  @override
  Future<List<Product>> getProductsByPage({
    int limit = 10,
    int offset = 0,
  }) async {
    return await ProductErrorHandle.handleDioError(() async {
      final response = await db.get('/products', queryParameters: {
        'limit': limit,
        'offset': offset,
      });

      final products =
          ProductsMapper.jsonProductsToEntities(List.from(response.data));
      return products;
    });
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) async {
    return await ProductErrorHandle.handleDioError(() async {
      final response = await db.get('/products/all/$term');
      final products = ProductsMapper.jsonProductsToEntities(response.data);
      return products;
    });
  }
}
