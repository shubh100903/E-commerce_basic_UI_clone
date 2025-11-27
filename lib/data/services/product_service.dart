/// data/services/product_service.dart
/// Remote data source for products and categories.

import '../models/category_model.dart';
import '../models/product_model.dart';
import 'api_client.dart';
import '../../core/constants/app_endpoints.dart';

class ProductService {
  ProductService(this._client);

  final ApiClient _client;

  Future<List<ProductModel>> fetchProducts() async {
    final data = await _client.get(AppEndpoints.products) as List<dynamic>;
    return data.map((json) => ProductModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final data = await _client.get(AppEndpoints.categories) as List<dynamic>;
    return data.map((json) => CategoryModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}

