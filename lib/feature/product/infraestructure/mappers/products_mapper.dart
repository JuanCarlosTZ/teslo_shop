import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/feature/auth/infraestructure/infraestructures.dart';
import 'package:teslo_shop/feature/product/domain/domains.dart';
import 'package:teslo_shop/feature/product/infraestructure/intraestructures.dart';

class ProductsMapper {
  static Product jsonProcuctToEntity(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: double.parse(json['price'].toString()),
      description: json['description'] ?? '',
      slug: json['slug'] ?? '',
      stock: int.parse(json['stock'].toString()),
      sizes: List<String>.from(json['sizes'].map((size) => size)),
      gender: json['gender'] ?? '',
      tags: List<String>.from(json['tags'].map((tags) => tags)),
      images: List<String>.from(json['images'].map((image) =>
          image.toString().startsWith('http')
              ? image
              : '${Environment.apiProductImageUrl}/$image')),
      user: UserMapper.userJsonToEntity(json['user']),
    );
  }

  static List<Product> jsonProductsToEntities(
      List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => jsonProcuctToEntity(json)).toList();
  }

  static Map<String, dynamic> productPayloadToJson(ProductPayload payload) {
    return <String, dynamic>{
      "id": payload.productId,
      "title": payload.title,
      "price": payload.price,
      "description": payload.description,
      "slug": payload.slug,
      "stock": payload.stock,
      "sizes": payload.sizes,
      "gender": payload.gender,
      "tags": payload.tags,
      "images": payload.images.map((image) {
        return image.replaceAll('${Environment.apiProductImageUrl}/', '');
      }).toList(),
    };
  }

  static ProductPayload productEntityToPayload(Product product) {
    return ProductPayload(
      productId: product.id,
      title: product.title,
      price: product.price,
      description: product.description,
      slug: product.slug,
      stock: product.stock,
      sizes: product.sizes,
      gender: product.gender,
      tags: product.tags,
      images: product.images,
    );
  }
}
