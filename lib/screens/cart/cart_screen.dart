import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../../widgets/common_widgets.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<CartProvider>();
    final items = cart.itemsList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () => _confirmClear(context),
              child: const Text('Vaciar', style: TextStyle(color: AppTheme.neonPink, fontSize: 14)),
            ),
        ],
      ),
      body: items.isEmpty
          ? EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Tu carrito está vacío',
              subtitle: '¡Agrega productos para empezar!',
              buttonLabel: 'Ir al catálogo',
              onButton: () => context.go('/catalog'),
            )
          : Column(children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return Dismissible(
                      key: Key(item.product.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.neonPink,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white, size: 28),
                      ),
                      onDismissed: (_) {
                        final removed = item;
                        context.read<CartProvider>().removeProduct(item.product.id);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${removed.product.name} eliminado'),
                          backgroundColor: theme.cardColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          action: SnackBarAction(
                            label: 'Deshacer',
                            textColor: AppTheme.neonPurple,
                            onPressed: () =>
                                context.read<CartProvider>().addProduct(removed.product),
                          ),
                        ));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: neonCardDecoration(context: context), // ← adapta fondo
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(children: [
                            // Imagen
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item.product.imageUrl,
                                width: 80, height: 80, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 80, height: 80,
                                  color: theme.cardColor,
                                  child: const Icon(Icons.gamepad, color: AppTheme.textMuted),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.product.platform,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    formatPrice(item.product.price),
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Selector cantidad
                            Column(children: [
                              _qBtn(context, Icons.add, theme.colorScheme.primary,
                                () => context.read<CartProvider>().addOne(item.product.id)),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  '${item.quantity}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              _qBtn(context, Icons.remove, theme.iconTheme.color ?? Colors.grey,
                                () => context.read<CartProvider>().removeOne(item.product.id)),
                            ]),
                          ]),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ── Resumen + checkout ────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  border: Border(top: BorderSide(color: theme.dividerColor)),
                ),
                child: Column(children: [
                  _row(
                    context,
                    'Subtotal',
                    formatPrice(cart.totalPrice),
                  ),
                  const SizedBox(height: 6),
                  _row(
                    context,
                    'Envío',
                    cart.shipping == 0 ? 'GRATIS' : formatPrice(cart.shipping),
                    vColor: cart.shipping == 0 ? AppTheme.neonGreen : null,
                  ),
                  if (cart.totalPrice < 500000)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Agrega ${formatPrice(500000 - cart.totalPrice)} más para envío gratis',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Divider(color: theme.dividerColor),
                  const SizedBox(height: 6),
                  _row(
                    context,
                    'TOTAL',
                    formatPrice(cart.grandTotal),
                    bold: true,
                    vColor: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () => _onCheckout(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: neonButtonDecoration(),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.payment, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text('FINALIZAR COMPRA',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800,
                                  fontSize: 16, letterSpacing: 0.8)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ]),
    );
  }

  // ── AlertDialog de confirmación ──────────────────────────────────────
  void _onCheckout(BuildContext context) {
    final theme = Theme.of(context);
    final auth   = context.read<AuthProvider>();
    final cart   = context.read<CartProvider>();
    final orders = context.read<OrdersProvider>();

    if (!auth.isLoggedIn) { context.go('/login'); return; }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirmar pedido',
          style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700)),
        content: Text(
          '¿Confirmas tu pedido por ${formatPrice(cart.grandTotal)}?',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              orders.placeOrder(
                userId: auth.currentUser!.id,
                items: cart.itemsList,
                total: cart.grandTotal,
              );
              cart.clear();
              Navigator.pop(context);
              context.go('/home');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Row(children: [
                  Icon(Icons.check_circle, color: AppTheme.neonGreen),
                  SizedBox(width: 8),
                  Text('¡Pedido confirmado! 🎉', style: TextStyle(color: AppTheme.textPrimary)),
                ]),
                backgroundColor: AppTheme.bgCard,
                behavior: SnackBarBehavior.floating,
              ));
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: const Text('¿Vaciar carrito?', style: TextStyle(color: AppTheme.textPrimary)),
        content: Text(
          'Se eliminarán todos los productos.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () { context.read<CartProvider>().clear(); Navigator.pop(context); },
            child: const Text('Vaciar', style: TextStyle(color: AppTheme.neonPink)),
          ),
        ],
      ),
    );
  }

  Widget _qBtn(BuildContext context, IconData icon, Color color, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
      );

  Widget _row(BuildContext context, String label, String value,
      {bool bold = false, Color? vColor}) {
    final theme = Theme.of(context);
    final labelColor = bold ? theme.textTheme.titleMedium?.color : theme.textTheme.bodyMedium?.color;
    final valueColor = vColor ?? (bold ? theme.textTheme.titleMedium?.color : theme.textTheme.bodyMedium?.color);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: bold ? 16 : 14,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: bold ? 18 : 14,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}