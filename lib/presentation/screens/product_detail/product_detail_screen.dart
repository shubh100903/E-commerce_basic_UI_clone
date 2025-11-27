/// presentation/screens/product_detail/product_detail_screen.dart
/// Immersive detail page with carousel and actions.

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/cart_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/section_header.dart';
import '../../../data/models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final navigation = context.watch<NavigationProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: navigation.goToListing,
        ),
        title: Text(product.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.xl),
              children: [
                Hero(
                  tag: 'product-${product.id}',
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 320,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                    ),
                    items: product.imageUrls
                        .map(
                          (image) => ClipRRect(
                            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                            child: Image.network(image, fit: BoxFit.cover),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: AppSizes.xl),
                SectionHeader(title: product.name),
                const SizedBox(height: AppSizes.sm),
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSizes.xl),
                Wrap(
                  spacing: AppSizes.md,
                  runSpacing: AppSizes.sm,
                  children: product.tags
                      .map(
                        (tag) => Chip(
                          label: Text(tag.toUpperCase()),
                          backgroundColor: AppColors.surface,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSizes.xl),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total', style: TextStyle(color: AppColors.textSecondary)),
                    Text(
                      '${product.currency} ${product.price.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppSizes.lg),
                    child: ElevatedButton(
                      onPressed: () => context.read<CartProvider>().add(product),
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(AppSizes.buttonHeight)),
                      child: const Text(AppStrings.addToCart),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

