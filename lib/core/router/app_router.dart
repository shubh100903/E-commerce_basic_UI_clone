/// core/router/app_router.dart
/// Implements Navigation 2.0 stack routing between key screens.

import 'package:flutter/material.dart';

import '../../presentation/providers/navigation_provider.dart';
import '../../presentation/screens/cart/cart_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/product_detail/product_detail_screen.dart';
import '../../presentation/screens/product_listing/product_listing_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';

/// Lightweight path object used by the route parser.
class AppRoutePath {
  const AppRoutePath(this.page);
  final AppPage page;
}

/// Parses incoming route information (deep links/bookmarks).
class AppRouteParser extends RouteInformationParser<AppRoutePath> {
  const AppRouteParser();

  @override
  Future<AppRoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final location = routeInformation.uri.pathSegments;
    if (location.isEmpty) {
      return const AppRoutePath(AppPage.home);
    }
    switch (location.first) {
      case 'listing':
        return const AppRoutePath(AppPage.listing);
      case 'cart':
        return const AppRoutePath(AppPage.cart);
      case 'profile':
        return const AppRoutePath(AppPage.profile);
      default:
        return const AppRoutePath(AppPage.home);
    }
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    switch (configuration.page) {
      case AppPage.listing:
        return RouteInformation(uri: Uri(path: '/listing'));
      case AppPage.cart:
        return RouteInformation(uri: Uri(path: '/cart'));
      case AppPage.profile:
        return RouteInformation(uri: Uri(path: '/profile'));
      case AppPage.detail:
        return RouteInformation(uri: Uri(path: '/detail'));
      case AppPage.home:
        return RouteInformation(uri: Uri(path: '/'));
    }
  }
}

/// RouterDelegate that reacts to [NavigationProvider] changes.
class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  AppRouterDelegate(this._navigation) {
    _navigation.addListener(notifyListeners);
  }

  final NavigationProvider _navigation;

  @override
  void dispose() {
    _navigation.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _buildPages(context),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        final handled = _navigation.onPop();
        if (!handled) {
          notifyListeners();
        }
        return handled;
      },
    );
  }

  List<Page<dynamic>> _buildPages(BuildContext context) {
    final pages = <Page<dynamic>>[
      MaterialPage(key: const ValueKey('home'), child: const HomeScreen()),
    ];

    switch (_navigation.currentPage) {
      case AppPage.home:
        break;
      case AppPage.listing:
        pages.add(
          MaterialPage(
            key: const ValueKey('listing'),
            child: const ProductListingScreen(),
          ),
        );
        break;
      case AppPage.detail:
        final product = _navigation.selectedProduct;
        if (product != null) {
          pages.add(
            MaterialPage(
              key: ValueKey('detail-${product.id}'),
              child: ProductDetailScreen(product: product),
            ),
          );
        }
        break;
      case AppPage.cart:
        pages.add(
          MaterialPage(key: const ValueKey('cart'), child: const CartScreen()),
        );
        break;
      case AppPage.profile:
        pages.add(
          MaterialPage(
            key: const ValueKey('profile'),
            child: const ProfileScreen(),
          ),
        );
        break;
    }
    return pages;
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    switch (configuration.page) {
      case AppPage.listing:
        _navigation.goToListing();
        break;
      case AppPage.cart:
        _navigation.goToCart();
        break;
      case AppPage.profile:
        _navigation.goToProfile();
        break;
      case AppPage.home:
      case AppPage.detail:
        _navigation.goHome();
        break;
    }
  }

  @override
  AppRoutePath? get currentConfiguration =>
      AppRoutePath(_navigation.currentPage);

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
