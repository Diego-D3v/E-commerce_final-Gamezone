import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/common_widgets.dart';

class ProfileShell extends StatelessWidget {
  const ProfileShell({super.key});
  @override
  Widget build(BuildContext context) => const ProfileScreen();
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth   = context.watch<AuthProvider>();
    final cart   = context.watch<CartProvider>();
    final wish   = context.watch<WishlistProvider>();
    final orders = context.watch<OrdersProvider>();

    if (!auth.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil'), automaticallyImplyLeading: false),
        body: EmptyState(
          icon: Icons.person_outline,
          title: 'No has iniciado sesión',
          subtitle: 'Inicia sesión para ver tu perfil',
          buttonLabel: 'Iniciar sesión',
          onButton: () => context.go('/login'),
        ),
      );
    }

    final user       = auth.currentUser!;
    final userOrders = orders.getOrdersByUser(user.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          // ── CircleAvatar + info ──────────────────────────────────
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Column(children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'G',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user.name,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Miembro desde ${user.createdAt.year}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                ),
              ),
            ]),
          ),

          // ── Stats ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              _stat(
                context,
                '${userOrders.length}',
                'Pedidos',
                Icons.receipt_long,
                AppTheme.neonPurple,
              ),
              const SizedBox(width: 10),
              _stat(
                context,
                '${wish.count}',
                'Favoritos',
                Icons.favorite,
                AppTheme.neonPink,
              ),
              const SizedBox(width: 10),
              _stat(
                context,
                '${cart.itemCount}',
                'Carrito',
                Icons.shopping_cart,
                AppTheme.neonBlue,
              ),
            ]),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 0, 0),
            child: Text(
              'PREFERENCIAS',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // ── SwitchListTile — FASE 9 ─────────────────────────────
          _SwitchesSection(),

          const Divider(color: AppTheme.borderColor, height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: Text(
              'CUENTA',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // ── Navegación ────────────────────────────────────────────
          _menuTile(
            context,
            Icons.receipt_long_outlined,
            'Mis pedidos',
            '${userOrders.length} pedidos',
            AppTheme.neonPurple,
            () => context.go('/orders'),
          ),
          _menuTile(
            context,
            Icons.favorite_border,
            'Lista de deseos',
            '${wish.count} guardados',
            AppTheme.neonPink,
            () => context.go('/wishlist'),
          ),
          _menuTile(
            context,
            Icons.shopping_cart_outlined,
            'Carrito',
            '${cart.itemCount} artículos',
            AppTheme.neonBlue,
            () => context.push('/cart'),
          ),
          _menuTile(
            context,
            Icons.edit_outlined,
            'Editar perfil',
            'Actualiza tu información',
            AppTheme.neonGreen,
            () => _editProfile(context),
          ),

          const Divider(color: AppTheme.borderColor, height: 1),

          // ── Cerrar sesión ──────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
            onTap: () {
              context.read<CartProvider>().clear();
              context.read<AuthProvider>().logout();
              context.go('/login');
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Widget helper: estadística ──────────────────────────────────────
  Widget _stat(BuildContext context, String value, String label, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: neonCardDecoration(glowColor: color, context: context),
        child: Column(children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
            ),
          ),
        ]),
      ),
    );
  }

  // ── Widget helper: menú ──────────────────────────────────────────────
  Widget _menuTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall,
      ),
      trailing: Icon(Icons.chevron_right, color: theme.iconTheme.color),
      onTap: onTap,
    );
  }

  // ── Editar perfil ────────────────────────────────────────────────────
  void _editProfile(BuildContext context) {
    final theme = Theme.of(context);
    final auth    = context.read<AuthProvider>();
    final nameCtrl = TextEditingController(text: auth.currentUser?.name);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Editar perfil',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameCtrl,
              style: theme.textTheme.bodyLarge,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: Icon(Icons.person_outline, color: AppTheme.textMuted),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty) {
                    auth.updateProfile(name: nameCtrl.text.trim());
                  }
                  Navigator.pop(ctx);
                },
                child: const Text('GUARDAR CAMBIOS'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── SwitchListTile section ───────────────────────────────────────────
class _SwitchesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.watch<SettingsProvider>();

    return Column(children: [
      SwitchListTile(
        title: Text(
          'Notificaciones',
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          'Recibir alertas de pedidos',
          style: theme.textTheme.bodySmall,
        ),
        value: settings.notificaciones,
        onChanged: (v) => context.read<SettingsProvider>().notificaciones = v,
        secondary: const Icon(Icons.notifications_outlined, color: AppTheme.neonPurple),
      ),
      SwitchListTile(
        title: Text(
          'Ofertas y promociones',
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          'Descuentos y novedades',
          style: theme.textTheme.bodySmall,
        ),
        value: settings.ofertas,
        onChanged: (v) => context.read<SettingsProvider>().ofertas = v,
        secondary: const Icon(Icons.local_offer_outlined, color: AppTheme.neonGreen),
      ),
      SwitchListTile(
        title: Text(
          'Modo oscuro',
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          'Siempre activo en GameZone ✨',
          style: theme.textTheme.bodySmall,
        ),
        value: settings.modoOscuro,
        onChanged: (v) => context.read<SettingsProvider>().modoOscuro = v,
        secondary: const Icon(Icons.dark_mode_outlined, color: AppTheme.neonBlue),
      ),
      const Divider(color: AppTheme.borderColor, height: 1),
    ]);
  }
}