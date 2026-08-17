import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/products/presentation/screens/product_detail_screen.dart';
import '../../features/products/presentation/screens/product_list_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../widgets/root_scaffold.dart';

/// Listenable bridge so `go_router` can react to Riverpod auth state
/// changes without rebuilding the whole router configuration.
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Ref ref) {
    ref.listen<AuthState>(authControllerProvider, (_, __) => notifyListeners());
  }
}

final Provider<GoRouter> routerProvider = Provider<GoRouter>((Ref ref) {
  final _AuthRefreshNotifier refreshNotifier = _AuthRefreshNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      final AuthState authState = ref.read(authControllerProvider);
      final bool isSplash = state.matchedLocation == '/';
      final bool isLoginRoute = state.matchedLocation == '/login';

      if (authState is AuthInitial || authState is AuthLoading) {
        return isSplash ? null : '/';
      }
      final bool isAuthenticated = authState is AuthAuthenticated;
      if (!isAuthenticated && !isLoginRoute) return '/login';
      if (isAuthenticated && (isLoginRoute || isSplash)) return '/products';
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: SplashScreen.routeName,
        builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: LoginScreen.routeName,
        builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return RootScaffold(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/products',
            name: ProductListScreen.routeName,
            builder: (BuildContext context, GoRouterState state) =>
                const ProductListScreen(),
            routes: <RouteBase>[
              GoRoute(
                path: ':id',
                name: ProductDetailScreen.routeName,
                builder: (BuildContext context, GoRouterState state) {
                  final int id = int.parse(state.pathParameters['id']!);
                  return ProductDetailScreen(productId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/favorites',
            name: FavoritesScreen.routeName,
            builder: (BuildContext context, GoRouterState state) =>
                const FavoritesScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: ProfileScreen.routeName,
            builder: (BuildContext context, GoRouterState state) =>
                const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
