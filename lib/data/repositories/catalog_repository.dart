/// data/repositories/catalog_repository.dart
/// Coordinates catalog fetching and lightweight caching.

import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class CatalogRepository {
  CatalogRepository(this._service);

  final ProductService _service;
  List<ProductModel>? _cachedProducts;
  List<CategoryModel>? _cachedCategories;

  Future<List<ProductModel>> getProducts({bool forceRefresh = false}) async {
    if (_cachedProducts == null || forceRefresh) {
      _cachedProducts = await _service.fetchProducts();
    }
    return _cachedProducts!;
  }

  Future<List<CategoryModel>> getCategories({bool forceRefresh = false}) async {
    if (_cachedCategories == null || forceRefresh) {
      _cachedCategories = await _service.fetchCategories();
    }
    return _cachedCategories!;
  }
}

