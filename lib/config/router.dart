import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/main_scaffold.dart';
import '../screens/product/product_detail_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/catalog/catalog_screen.dart';
import '../screens/wishlist/wishlist_screen.dart';
import '../screens/profile/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final auth = context.read<AuthProvider>();
    final loc  = state.matchedLocation;
    final isAuth = loc == '/login' || loc == '/register';
    if (!auth.isLoggedIn && !isAuth) return '/login';
    if (auth.isLoggedIn && isAuth) return '/home';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      pageBuilder: (_, s) => _fade(s, const LoginScreen()),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (_, s) => _fade(s, const RegisterScreen()),
    ),
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(path: '/home',     pageBuilder: (_, s) => _noT(s, const HomeShell())),
        GoRoute(path: '/catalog',  pageBuilder: (_, s) => _noT(s, const CatalogShell())),
        GoRoute(path: '/wishlist', pageBuilder: (_, s) => _noT(s, const WishlistShell())),
        GoRoute(path: '/orders',   pageBuilder: (_, s) => _noT(s, const OrdersShell())),
        GoRoute(path: '/profile',  pageBuilder: (_, s) => _noT(s, const ProfileShell())),
      ],
    ),
    GoRoute(
      path: '/product/:id',
      pageBuilder: (_, s) => _slide(s, ProductDetailScreen(productId: s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/cart',
      pageBuilder: (_, s) => _slide(s, const CartScreen()),
    ),
  ],
);

CustomTransitionPage _fade(GoRouterState s, Widget child) => CustomTransitionPage(
  key: s.pageKey, child: child,
  transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
  transitionDuration: const Duration(milliseconds: 300),
);

CustomTransitionPage _slide(GoRouterState s, Widget child) => CustomTransitionPage(
  key: s.pageKey, child: child,
  transitionsBuilder: (_, a, __, c) => SlideTransition(
    position: Tween(begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
    child: c,
  ),
  transitionDuration: const Duration(milliseconds: 320),
);

NoTransitionPage _noT(GoRouterState s, Widget child) =>
    NoTransitionPage(key: s.pageKey, child: child);
