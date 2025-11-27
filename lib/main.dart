
/// Bootstraps providers, theme, and Navigation 2.0 router.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/cart_repository.dart';
import 'data/repositories/catalog_repository.dart';
import 'data/repositories/profile_repository.dart';
import 'data/services/api_client.dart';
import 'data/services/cart_service.dart';
import 'data/services/product_service.dart';
import 'data/services/profile_service.dart';
import 'presentation/providers/cart_provider.dart';
import 'presentation/providers/catalog_provider.dart';
import 'presentation/providers/navigation_provider.dart';
import 'presentation/providers/profile_provider.dart';

void main() {
  runApp(const LuminCommerceApp());
}

class LuminCommerceApp extends StatelessWidget {
  const LuminCommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiClient()),
        ProxyProvider<ApiClient, CatalogRepository>(
          update: (_, client, __) => CatalogRepository(ProductService(client)),
        ),
        ProxyProvider<ApiClient, CartRepository>(
          update: (_, client, __) => CartRepository(CartService(client)),
        ),
        ProxyProvider<ApiClient, ProfileRepository>(
          update: (_, client, __) => ProfileRepository(ProfileService(client)),
        ),
        ChangeNotifierProvider(
          create: (context) => CatalogProvider(context.read<CatalogRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(context.read<CartRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(context.read<ProfileRepository>()),
        ),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: Consumer<NavigationProvider>(
        builder: (context, navigation, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Lumin E-Store',
            theme: AppTheme.buildTheme(),
            routerDelegate: AppRouterDelegate(navigation),
            routeInformationParser: const AppRouteParser(),
          );
        },
      ),
    );
  }
}
