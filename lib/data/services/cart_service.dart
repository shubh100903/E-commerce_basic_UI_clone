/// data/services/cart_service.dart
/// Handles cart mutation calls.

import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import 'api_client.dart';
import '../../core/constants/app_endpoints.dart';

class CartService {
  CartService(this._client);

  final ApiClient _client;

  Future<List<CartItemModel>> fetchCart() async {
    final data = await _client.get(AppEndpoints.cart) as List<dynamic>;
    return data.map((json) => CartItemModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    await _client.post(AppEndpoints.cart, body: {
      'productId': product.id,
      'quantity': quantity,
    });
  }
}

