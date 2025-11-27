# Lumin E-Store (Flutter)

Neo-noir OLED e-commerce UI that showcases a modern Amazon/Flipkart-inspired shopping flow built purely in Flutter with Provider and Navigation 2.0.

## Highlights
- OLED true-black palette (`#000000`, `#121212`, `#00D4AA`, `#FF4B4B`) with Space Grotesk typography.
- Screens: Home, Catalog Listing, Product Detail (carousel + hero), Cart, Profile.
- Provider-powered business logic (catalog, cart, profile, navigation) with documented ChangeNotifiers.
- Navigation 2.0 stack via custom `RouterDelegate`/`RouteInformationParser`.
- REST-ready services + repositories with centralized `ApiClient`, graceful fallbacks, and loading/error states.
- Responsive grids, animated page/content transitions, shimmer overlay, and WCAG-compliant contrast.

## Architecture
```
lib/
 ├─ core/        # theme, constants, router
 ├─ data/        # models, services, repositories
 ├─ presentation/
 │   ├─ providers
 │   ├─ screens
 │   └─ widgets/components
 └─ main.dart    # app bootstrap + provider wiring
```

### Data & API
- Configure the REST base URL or endpoint paths in `lib/core/constants/app_endpoints.dart`.
- `ApiClient` wraps `http` with JSON decoding + error bubbling.
- Repositories provide lightweight caching and isolate UI from network concerns.

## Run & Test
```bash
flutter pub get
flutter run            # choose desired device
flutter test           # widget/basic tests
```

## Design & Accessibility
- All surfaces honor OLED blacks to save power on AMOLED displays.
- Text hierarchy maintains WCAG AA/AAA contrast; large touch targets and haptics-ready controls.
- Layout adapts to tablet breakpoints (responsive grid column math).

## Next Steps
- Point the services at your live API, or replace with mock servers for demos.
- Extend providers with pagination, auth, and checkout flows as needed.
