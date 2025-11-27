/// presentation/providers/catalog_provider.dart
/// Holds product, category, and search state for catalog flows.

import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/catalog_repository.dart';

enum CatalogStatus { idle, loading, error }

class CatalogProvider extends ChangeNotifier {
  CatalogProvider(this._repository);

  final CatalogRepository _repository;

  CatalogStatus _status = CatalogStatus.idle;
  CatalogStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ProductModel> _products = <ProductModel>[];
  List<CategoryModel> _categories = <CategoryModel>[];

  String _searchQuery = '';
  String? _selectedCategoryId;

  Future<void> load() async {
    _status = CatalogStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _repository.getProducts();
      _categories = await _repository.getCategories();
      _status = CatalogStatus.idle;
    } catch (error) {
      _products = _fallbackProducts;
      _categories = _fallbackCategories;
      _errorMessage = 'Unable to reach storefront. Showing sample data.';
      _status = CatalogStatus.error;
    }
    notifyListeners();
  }

  void selectCategory(String? id) {
    _selectedCategoryId = id;
    notifyListeners();
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    _products = _products
        .map(
          (product) => product.id == productId
              ? product.copyWith(isFavorite: !product.isFavorite)
              : product,
        )
        .toList();
    notifyListeners();
  }

  List<ProductModel> get featuredProducts => _products.take(6).toList();

  List<ProductModel> get filteredProducts {
    return _products.where((product) {
      final matchesCategory = _selectedCategoryId == null || product.categoryId == _selectedCategoryId;
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.brand.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<CategoryModel> get categories => _categories.isEmpty ? _fallbackCategories : _categories;

  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;

  bool get isLoading => _status == CatalogStatus.loading;

  List<ProductModel> get recommendedProducts {
    final list = [..._products];
    list.shuffle(Random());
    return list.take(8).toList();
  }

  List<ProductModel> get recentlyViewed => _products.reversed.take(4).toList();

  List<ProductModel> get limitedSaleProducts =>
      _products.where((product) => product.tags.contains('sale')).take(4).toList();

  List<ProductModel> get _fallbackProducts => List<ProductModel>.generate(
        10,
        (index) => ProductModel(
          id: 'demo-$index',
          name: 'Neo Pulse ${index + 1}',
          brand: 'Luminex',
          price: 199 + index * 12.5,
          currency: 'USD',
          imageUrls: [
            'https://picsum.photos/id/${index + 40}/600/600',
            'https://picsum.photos/id/${index + 70}/600/600',
          ],
          rating: 4 + (index % 2) * 0.5,
          tags: index.isEven ? ['new', 'sale'] : ['popular'],
          description:
              'Tactile materials with recycled alloys and luminous trims. ${AppStrings.featured}.',
          categoryId: _fallbackCategories[index % _fallbackCategories.length].id,
          isFavorite: index.isEven,
          stock: 50 - index * 2,
        ),
      );

  List<CategoryModel> get _fallbackCategories => const [
        CategoryModel(id: 'all', label: 'All', icon: 'assets/icons/infinity.svg'),
        CategoryModel(id: 'wearables', label: 'Wearables', icon: 'assets/icons/watch.svg'),
        CategoryModel(id: 'audio', label: 'Audio', icon: 'assets/icons/audio.svg'),
        CategoryModel(id: 'home', label: 'Home', icon: 'assets/icons/home.svg'),
        CategoryModel(id: 'gaming', label: 'Gaming', icon: 'assets/icons/game.svg'),
      ];
}

