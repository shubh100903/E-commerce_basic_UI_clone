/// data/models/product_model.dart
/// Represents a product entity with serialization helpers.

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.currency,
    required this.imageUrls,
    required this.rating,
    required this.tags,
    required this.description,
    required this.categoryId,
    this.isFavorite = false,
    this.stock = 0,
  });

  final String id;
  final String name;
  final String brand;
  final double price;
  final String currency;
  final List<String> imageUrls;
  final double rating;
  final List<String> tags;
  final String description;
  final String categoryId;
  final bool isFavorite;
  final int stock;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        brand: json['brand'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        currency: json['currency'] ?? 'USD',
        imageUrls: List<String>.from(json['images'] ?? <String>[]),
        rating: (json['rating'] ?? 0).toDouble(),
        tags: List<String>.from(json['tags'] ?? <String>[]),
        description: json['description'] ?? '',
        categoryId: json['categoryId']?.toString() ?? '',
        isFavorite: json['isFavorite'] ?? false,
        stock: json['stock'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'brand': brand,
        'price': price,
        'currency': currency,
        'images': imageUrls,
        'rating': rating,
        'tags': tags,
        'description': description,
        'categoryId': categoryId,
        'isFavorite': isFavorite,
        'stock': stock,
      };

  ProductModel copyWith({
    String? id,
    String? name,
    String? brand,
    double? price,
    String? currency,
    List<String>? imageUrls,
    double? rating,
    List<String>? tags,
    String? description,
    String? categoryId,
    bool? isFavorite,
    int? stock,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      imageUrls: imageUrls ?? this.imageUrls,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
      stock: stock ?? this.stock,
    );
  }
}

