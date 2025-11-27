/// data/models/cart_item_model.dart
/// Represents a product entry in the user's cart.

import 'product_model.dart';

class CartItemModel {
  CartItemModel({
    required this.product,
    required this.quantity,
  });

  final ProductModel product;
  final int quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        product: ProductModel.fromJson(json['product'] ?? <String, dynamic>{}),
        quantity: json['quantity'] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  double get total => quantity * product.price;
}

