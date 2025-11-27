/// data/models/category_model.dart
/// Defines a product category used for browsing and filtering.

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.label,
    required this.icon,
    this.isFeatured = false,
  });

  final String id;
  final String label;
  final String icon;
  final bool isFeatured;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id']?.toString() ?? '',
        label: json['label'] ?? '',
        icon: json['icon'] ?? '',
        isFeatured: json['isFeatured'] ?? false,
      );
}

