/// presentation/providers/navigation_provider.dart
/// Coordinates top-level navigation state for RouterDelegate.

import 'package:flutter/material.dart';

import '../../data/models/product_model.dart';

enum AppPage { home, listing, detail, cart, profile }

class NavigationProvider extends ChangeNotifier {
  AppPage _currentPage = AppPage.home;
  ProductModel? _selectedProduct;

  AppPage get currentPage => _currentPage;
  ProductModel? get selectedProduct => _selectedProduct;

  void goHome() {
    _currentPage = AppPage.home;
    _selectedProduct = null;
    notifyListeners();
  }

  void goToListing() {
    _currentPage = AppPage.listing;
    _selectedProduct = null;
    notifyListeners();
  }

  void goToDetail(ProductModel product) {
    _currentPage = AppPage.detail;
    _selectedProduct = product;
    notifyListeners();
  }

  void goToCart() {
    _currentPage = AppPage.cart;
    notifyListeners();
  }

  void goToProfile() {
    _currentPage = AppPage.profile;
    notifyListeners();
  }

  bool onPop() {
    if (_currentPage == AppPage.detail) {
      goToListing();
      return true;
    }
    if (_currentPage != AppPage.home) {
      goHome();
      return true;
    }
    return false;
  }
}

