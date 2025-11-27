/// presentation/screens/product_listing/product_listing_screen.dart
/// Displays the full catalog with filters and toggles.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../components/neo_search_bar.dart';
import '../../providers/catalog_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/error_banner.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/product_card.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  bool isGrid = true;

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final navigation = context.watch<NavigationProvider>();
    final products = catalog.filteredProducts;
    final gridColumns = _gridColumns(context);
    final aspectRatio = _gridAspectRatio(gridColumns);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: navigation.goHome,
        ),
        actions: [
          IconButton(
            icon: Icon(isGrid ? Icons.grid_view : Icons.view_agenda),
            onPressed: () => setState(() => isGrid = !isGrid),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.xl),
            child: Column(
              children: [
                NeoSearchBar(
                  hintText: AppStrings.searchHint,
                  initialValue: catalog.searchQuery,
                  onChanged: catalog.updateSearch,
                ),
                const SizedBox(height: AppSizes.lg),
                SizedBox(
                  height: 52,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: catalog.categories.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppSizes.md),
                    itemBuilder: (context, index) {
                      final category = catalog.categories[index];
                      return CategoryChip(
                        category: category,
                        isSelected: catalog.selectedCategoryId == category.id,
                        onTap: () => catalog.selectCategory(
                          category.id == 'all' ? null : category.id,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                if (catalog.errorMessage != null) ...[
                  ErrorBanner(
                    message: catalog.errorMessage!,
                    onRetry: () => catalog.load(),
                  ),
                  const SizedBox(height: AppSizes.lg),
                ],
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: isGrid
                        ? GridView.builder(
                            key: const ValueKey('grid'),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: gridColumns,
                                  crossAxisSpacing: AppSizes.md,
                                  mainAxisSpacing: AppSizes.md,
                                  childAspectRatio: aspectRatio,
                                ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return ProductCard(
                                product: product,
                                onTap: () => navigation.goToDetail(product),
                                onFavorite: () =>
                                    catalog.toggleFavorite(product.id),
                                onAddToCart: () =>
                                    context.read<CartProvider>().add(product),
                              );
                            },
                          )
                        : ListView.separated(
                            key: const ValueKey('list'),
                            itemCount: products.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: AppSizes.md),
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return ProductCard(
                                product: product,
                                onTap: () => navigation.goToDetail(product),
                                onFavorite: () =>
                                    catalog.toggleFavorite(product.id),
                                onAddToCart: () =>
                                    context.read<CartProvider>().add(product),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          LoadingOverlay(isVisible: catalog.isLoading),
        ],
      ),
    );
  }

  int _gridColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1200) return 4;
    if (width >= 840) return 3;
    return 2;
  }

  double _gridAspectRatio(int columns) => columns >= 3 ? 0.75 : 0.68;
}
