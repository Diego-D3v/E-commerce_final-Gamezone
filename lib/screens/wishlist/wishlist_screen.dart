import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../widgets/common_widgets.dart';

// ══════════════════════════════════════════════════════════════════════
// WISHLIST
// ══════════════════════════════════════════════════════════════════════
class WishlistShell extends StatelessWidget {
  const WishlistShell({super.key});
  @override
  Widget build(BuildContext context) => const WishlistScreen();
}

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        automaticallyImplyLeading: false,
        actions: [
          if (wishlist.items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(child: NeonBadge(text: '${wishlist.count}', color: AppTheme.neonPink)),
            ),
        ],
      ),
      body: wishlist.items.isEmpty
          ? const EmptyState(
              icon: Icons.favorite_border,
              title: 'Sin favoritos aún',
              subtitle: 'Guarda productos que te interesen para verlos después',
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.48,
                crossAxisSpacing: 12, mainAxisSpacing: 12,
              ),
              itemCount: wishlist.items.length,
              itemBuilder: (_, i) => ProductCard(product: wishlist.items[i]),
            ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// ORDERS
// ══════════════════════════════════════════════════════════════════════
class OrdersShell extends StatelessWidget {
  const OrdersShell({super.key});
  @override
  Widget build(BuildContext context) => const OrdersScreen();
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  Color _statusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:    return AppTheme.neonOrange;
      case OrderStatus.processing: return AppTheme.neonBlue;
      case OrderStatus.shipped:    return AppTheme.neonPurple;
      case OrderStatus.delivered:  return AppTheme.neonGreen;
      case OrderStatus.cancelled:  return AppTheme.neonPink;
    }
  }

  IconData _statusIcon(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:    return Icons.schedule;
      case OrderStatus.processing: return Icons.autorenew;
      case OrderStatus.shipped:    return Icons.local_shipping;
      case OrderStatus.delivered:  return Icons.check_circle;
      case OrderStatus.cancelled:  return Icons.cancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth   = context.watch<AuthProvider>();
    final orders = context.watch<OrdersProvider>();

    if (!auth.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pedidos'), automaticallyImplyLeading: false),
        body: EmptyState(
          icon: Icons.receipt_long_outlined,
          title: 'Inicia sesión',
          subtitle: 'Para ver tu historial de pedidos',
          buttonLabel: 'Iniciar sesión',
          onButton: () => context.go('/login'),
        ),
      );
    }

    final userOrders = orders.getOrdersByUser(auth.currentUser!.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Pedidos'), automaticallyImplyLeading: false),
      body: userOrders.isEmpty
          ? EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'Sin pedidos aún',
              subtitle: 'Tus compras aparecerán aquí',
              buttonLabel: 'Explorar catálogo',
              onButton: () => context.go('/catalog'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: userOrders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final order = userOrders[i];
                final sc = _statusColor(order.status);
                return Container(
                  decoration: neonCardDecoration(glowColor: sc),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(order.id, style: const TextStyle(color: AppTheme.neonPurple,
                                fontSize: 13, fontWeight: FontWeight.w700)),
                            Text('${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                              style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                          ]),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: sc.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: sc.withValues(alpha: 0.4)),
                          ),
                          child: Row(children: [
                            Icon(_statusIcon(order.status), color: sc, size: 12),
                            const SizedBox(width: 4),
                            Text(order.statusLabel,
                              style: TextStyle(color: sc, fontSize: 12, fontWeight: FontWeight.w700)),
                          ]),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      const Divider(color: AppTheme.borderColor, height: 1),
                      const SizedBox(height: 10),
                      ...order.items.take(2).map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(item.product.imageUrl,
                              width: 40, height: 40, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 40, height: 40, color: AppTheme.bgCardLight,
                                child: const Icon(Icons.gamepad, size: 20, color: AppTheme.textMuted))),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(item.product.name,
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                            maxLines: 1, overflow: TextOverflow.ellipsis)),
                          Text('x${item.quantity}',
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                        ]),
                      )),
                      if (order.items.length > 2)
                        Text('+${order.items.length - 2} más',
                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                      const SizedBox(height: 8),
                      const Divider(color: AppTheme.borderColor, height: 1),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${order.items.fold(0, (s, i) => s + i.quantity)} artículos',
                            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                          Text(formatPrice(order.total),
                            style: const TextStyle(color: AppTheme.neonGreen,
                                fontSize: 16, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
