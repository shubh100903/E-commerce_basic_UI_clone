/// presentation/screens/home/home_screen.dart
/// Landing view with featured drops, categories, and recommendations.

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../components/neo_search_bar.dart';
import '../../providers/catalog_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/profile_provider.dart';
import '../../../data/models/product_model.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/error_banner.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatalogProvider>().load();
      context.read<ProfileProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigation = context.watch<NavigationProvider>();
    return Scaffold(
      body: SafeArea(
        child: Consumer<CatalogProvider>(
          builder: (context, catalog, _) {
            final gridColumns = _gridColumns(context);
            final aspectRatio = _gridAspectRatio(gridColumns);
            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: catalog.load,
                  backgroundColor: AppColors.surface,
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(AppSizes.xl),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _HomeTopBar(
                                onCartTap: navigation.goToCart,
                                onProfileTap: navigation.goToProfile,
                              ),
                              const SizedBox(height: AppSizes.xl),
                              NeoSearchBar(
                                hintText: AppStrings.searchHint,
                                initialValue: catalog.searchQuery,
                                onChanged: catalog.updateSearch,
                              ),
                              const SizedBox(height: AppSizes.xl),
                              if (catalog.errorMessage != null)
                                ErrorBanner(
                                  message: catalog.errorMessage!,
                                  onRetry: () => catalog.load(),
                                ),
                              const SizedBox(height: AppSizes.lg),
                              SectionHeader(
                                title: AppStrings.categories,
                                actionLabel: 'See all',
                                onActionTap: navigation.goToListing,
                              ),
                              const SizedBox(height: AppSizes.md),
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
                                      isSelected:
                                          catalog.selectedCategoryId ==
                                          category.id,
                                      onTap: () => catalog.selectCategory(
                                        category.id == 'all'
                                            ? null
                                            : category.id,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: AppSizes.xl),
                              SectionHeader(
                                title: AppStrings.featured,
                                actionLabel: 'Browse',
                                onActionTap: navigation.goToListing,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 220,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.85,
                          ),
                          items: catalog.featuredProducts
                              .map(
                                (product) => _FeaturedCard(
                                  product: product,
                                  onTap: () => navigation.goToDetail(product),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(AppSizes.xl),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final product = catalog.recommendedProducts[index];
                            return ProductCard(
                              product: product,
                              onTap: () => navigation.goToDetail(product),
                              onFavorite: () =>
                                  catalog.toggleFavorite(product.id),
                              onAddToCart: () =>
                                  context.read<CartProvider>().add(product),
                            );
                          }, childCount: catalog.recommendedProducts.length),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: gridColumns,
                                childAspectRatio: aspectRatio,
                                crossAxisSpacing: AppSizes.md,
                                mainAxisSpacing: AppSizes.md,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                LoadingOverlay(isVisible: catalog.isLoading),
              ],
            );
          },
        ),
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

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar({required this.onCartTap, required this.onProfileTap});
  final VoidCallback onCartTap;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Spacer(),
        IconButton(
          onPressed: onCartTap,
          icon: const Icon(Icons.shopping_bag_outlined),
        ),
        IconButton(
          onPressed: onProfileTap,
          icon: const Icon(Icons.person_outline),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.product, required this.onTap});
  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm,
          vertical: AppSizes.md,
        ),
        padding: const EdgeInsets.all(AppSizes.xl),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          gradient: LinearGradient(
            colors: [AppColors.surface, AppColors.surface.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.brand.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const Spacer(),
            Text(product.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSizes.sm),
            Text(
              '${product.currency} ${product.price.toStringAsFixed(0)}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
