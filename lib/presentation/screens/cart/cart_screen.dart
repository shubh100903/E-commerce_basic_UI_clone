/// presentation/screens/cart/cart_screen.dart
/// Summarizes cart items, totals, and checkout action.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/cart_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/error_banner.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/cart_item_tile.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final navigation = context.watch<NavigationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: navigation.goHome,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.xl),
            child: Column(
              children: [
                if (cart.error != null) ...[
                  ErrorBanner(
                    message: cart.error!,
                    onRetry: () => cart.loadCart(),
                  ),
                  const SizedBox(height: AppSizes.lg),
                ],
                Expanded(
                  child: cart.items.isEmpty
                      ? const _EmptyCart()
                      : ListView.builder(
                          itemCount: cart.items.length,
                          itemBuilder: (context, index) {
                            final item = cart.items[index];
                            return CartItemTile(
                              item: item,
                              onIncrement: () =>
                                  cart.increment(item.product.id),
                              onDecrement: () =>
                                  cart.decrement(item.product.id),
                            );
                          },
                        ),
                ),
                const SizedBox(height: AppSizes.lg),
                _CartTotal(
                  subtotal: cart.subtotal,
                  shipping: cart.shipping,
                  total: cart.total,
                ),
              ],
            ),
          ),
          LoadingOverlay(isVisible: cart.isLoading),
        ],
      ),
    );
  }
}

class _CartTotal extends StatelessWidget {
  const _CartTotal({
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  final double subtotal;
  final double shipping;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          _Row(label: 'Subtotal', value: subtotal),
          _Row(label: 'Shipping', value: shipping),
          const Divider(),
          _Row(label: 'Total', value: total, isBold: true),
          const SizedBox(height: AppSizes.lg),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
            ),
            child: const Text(AppStrings.checkout),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.isBold = false});
  final String label;
  final double value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: isBold
                ? Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: AppColors.primary)
                : Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.shopping_bag_outlined,
          size: 64,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppSizes.lg),
        Text(
          AppStrings.cartEmpty,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
