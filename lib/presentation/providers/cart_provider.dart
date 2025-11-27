/// presentation/providers/cart_provider.dart
/// Manages cart contents, totals, and async sync operations.

import 'package:flutter/material.dart';

import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {
  CartProvider(this._repository);

  final CartRepository _repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  final List<CartItemModel> _items = <CartItemModel>[];

  List<CartItemModel> get items => List.unmodifiable(_items);

  Future<void> loadCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _items
        ..clear()
        ..addAll(await _repository.fetchCart());
    } catch (error) {
      _error = 'Unable to update cart right now.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(ProductModel product) async {
    try {
      await _repository.add(product);
      final index = _items.indexWhere((item) => item.product.id == product.id);
      if (index == -1) {
        _items.add(CartItemModel(product: product, quantity: 1));
      } else {
        _items[index] = _items[index].copyWith(
          quantity: _items[index].quantity + 1,
        );
      }
      _error = null;
    } catch (error) {
      _error = 'Unable to add item to cart right now.';
    } finally {
      notifyListeners();
    }
  }

  void increment(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index == -1) return;
    _items[index] = _items[index].copyWith(
      quantity: _items[index].quantity + 1,
    );
    notifyListeners();
  }

  void decrement(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index == -1) return;
    final current = _items[index];
    if (current.quantity == 1) {
      _items.removeAt(index);
    } else {
      _items[index] = current.copyWith(quantity: current.quantity - 1);
    }
    notifyListeners();
  }

  double get subtotal => _items.fold(0, (sum, item) => sum + item.total);
  double get shipping => _items.isEmpty ? 0 : 8.5;
  double get total => subtotal + shipping;
}
