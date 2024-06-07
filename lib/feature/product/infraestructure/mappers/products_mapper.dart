import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/feature/auth/infraestructure/infraestructures.dart';
import 'package:teslo_shop/feature/product/domain/domains.dart';

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
}
