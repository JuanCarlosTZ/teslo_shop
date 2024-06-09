class ProductPayload {
  final String? productId;
  final String title;
  final double price;
  final String description;
  final String slug;
  final int stock;
  final List<String> sizes;
  final String gender;
  final List<String> tags;
  final List<String> images;

  ProductPayload({
    this.productId,
    required this.title,
    required this.price,
    required this.description,
    required this.slug,
    required this.stock,
    required this.sizes,
    required this.gender,
    required this.tags,
    required this.images,
  });
  ProductPayload copyWith({
    String? title,
    double? price,
    String? description,
    String? slug,
    int? stock,
    List<String>? sizes,
    String? gender,
    List<String>? tags,
    List<String>? images,
  }) {
    return ProductPayload(
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
