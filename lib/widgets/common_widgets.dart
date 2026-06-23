import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

// ── Precio formateado ─────────────────────────────────────────────────
String formatPrice(double v) {
  final s = v.toInt().toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return '\$${buf.toString()}';
}

// ── Neon Badge ────────────────────────────────────────────────────────
class NeonBadge extends StatelessWidget {
  final String text;
  final Color color;
  const NeonBadge({super.key, required this.text, this.color = AppTheme.neonPurple});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: color.withValues(alpha: 0.5)),
    ),
    child: Text(text,
      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
  );
}

// ── Price Display ─────────────────────────────────────────────────────
class PriceDisplay extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final double fontSize;
  const PriceDisplay({super.key, required this.price, this.originalPrice, this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary; // neonPurple
    final mutedColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatPrice(price),
          style: TextStyle(
            color: primaryColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        if (originalPrice != null && originalPrice! > price)
          Text(
            formatPrice(originalPrice!),
            style: TextStyle(
              color: mutedColor,
              fontSize: fontSize - 3,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }
}

// ── Product Card — con Hero animation ────────────────────────────────
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wishlist = context.watch<WishlistProvider>();
    final cart     = context.watch<CartProvider>();
    final inCart   = cart.contains(product.id);
    final isWish   = wishlist.isInWishlist(product.id);

    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        decoration: neonCardDecoration(context: context), // ← contexto para adaptar fondo
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Imagen con Hero ───────────────────────────────────
            Stack(
              children: [
                Hero(
                  tag: 'product-${product.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: theme.cardColor,
                          child: const Icon(Icons.gamepad, color: AppTheme.textMuted, size: 48),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8, left: 8,
                  child: Column(children: [
                    if (product.isNew) const NeonBadge(text: 'NUEVO', color: AppTheme.neonBlue),
                    if (product.hasDiscount) ...[
                      const SizedBox(height: 4),
                      NeonBadge(text: '-${product.discountPercent.toInt()}%', color: AppTheme.neonPink),
                    ],
                  ]),
                ),
                Positioned(
                  top: 6, right: 6,
                  child: GestureDetector(
                    onTap: () => wishlist.toggle(product),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.cardColor.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isWish ? Icons.favorite : Icons.favorite_border,
                        color: isWish ? AppTheme.neonPink : theme.iconTheme.color,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // ── Info ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plataforma
                  Text(
                    product.platform,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Nombre
                  Text(
                    product.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Rating
                  Row(children: [
                    RatingBarIndicator(
                      rating: product.rating,
                      itemBuilder: (_, __) => const Icon(Icons.star, color: Color(0xFFFFB800)),
                      itemCount: 5, itemSize: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product.rating}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ]),
                  const SizedBox(height: 6),
                  // Precio
                  PriceDisplay(
                    price: product.price,
                    originalPrice: product.originalPrice,
                    fontSize: 14,
                  ),
                  const SizedBox(height: 8),
                  // Botón agregar
                  GestureDetector(
                    onTap: () => context.read<CartProvider>().addProduct(product),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: inCart
                          ? neonButtonDecoration(color: AppTheme.neonGreen)
                          : neonButtonDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(inCart ? Icons.check : Icons.add_shopping_cart,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(inCart ? 'En carrito' : 'Agregar',
                            style: const TextStyle(color: Colors.white,
                                fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  const SectionHeader({super.key, required this.title, this.subtitle, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.displaySmall,
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                  ),
                ),
            ],
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text(
              'Ver todo',
              style: TextStyle(color: AppTheme.neonPurple, fontSize: 13),
            ),
          ),
      ],
    );
  }
}

// ── Cart Badge AppBar Action ──────────────────────────────────────────
class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.watch<CartProvider>().itemCount;
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.shopping_cart_outlined, color: theme.iconTheme.color),
          onPressed: () => context.push('/cart'),
        ),
        if (count > 0)
          Positioned(
            right: 6, top: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: AppTheme.neonPurple, shape: BoxShape.circle),
              child: Text(
                '$count',
                style: TextStyle(
                  color: theme.textTheme.bodySmall?.color ?? Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonLabel;
  final VoidCallback? onButton;
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    this.onButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.cardColor,
                shape: BoxShape.circle,
                border: Border.all(color: theme.dividerColor),
              ),
              child: Icon(icon, color: theme.iconTheme.color, size: 48),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (buttonLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onButton,
                child: Text(buttonLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}