import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/wishlist_provider.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  static const _tabs = ['/home', '/catalog', '/wishlist', '/orders', '/profile'];

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    final idx = _tabs.indexWhere((t) => loc.startsWith(t));
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    final wishCount = context.watch<WishlistProvider>().count;
    final current   = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.bgSecondary,
          border: Border(top: BorderSide(color: AppTheme.borderColor)),
        ),
        child: BottomNavigationBar(
          currentIndex: current,
          onTap: (i) => context.go(_tabs[i]),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined), activeIcon: Icon(Icons.grid_view), label: 'Catálogo'),
            BottomNavigationBarItem(
              icon: Stack(children: [
                const Icon(Icons.favorite_border),
                if (wishCount > 0)
                  Positioned(right: 0, top: 0, child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: AppTheme.neonPink, shape: BoxShape.circle),
                    child: Text('$wishCount',
                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700)),
                  )),
              ]),
              activeIcon: const Icon(Icons.favorite),
              label: 'Favoritos',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Pedidos'),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
