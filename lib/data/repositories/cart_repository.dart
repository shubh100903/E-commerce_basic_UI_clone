/// data/repositories/cart_repository.dart
/// Abstracts cart operations from UI layers.

import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';

class CartRepository {
  CartRepository(this._service);

  final CartService _service;

  Future<List<CartItemModel>> fetchCart() => _service.fetchCart();

  Future<void> add(ProductModel product, {int quantity = 1}) => _service.addToCart(
        product,
        quantity: quantity,
      );
}

