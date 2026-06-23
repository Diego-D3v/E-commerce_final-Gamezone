import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../data/product_data.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/common_widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _addToCart(Product product) {
    context.read<CartProvider>().addProduct(product, quantity: _quantity);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      final snackBar = ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '¡$_quantity ${product.name} agregado(s) al carrito!',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Timer(const Duration(seconds: 2), () => snackBar.close());
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = findProductById(widget.productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
        body: const Center(child: Text('Producto no encontrado')),
      );
    }

    final cart = context.watch<CartProvider>();
    final wishlist = context.watch<WishlistProvider>();
    final inCart = cart.contains(product.id);
    final isWish = wishlist.isInWishlist(product.id);

    final related = kProducts
        .where((p) => p.category == product.category && p.id != product.id)
        .take(6)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar con Hero image ────────────────────────
          SliverAppBar(
            expandedHeight: 250, // <--- (1) Reducido de 280 a 250
            pinned: true,
            backgroundColor: AppTheme.bgPrimary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.bgCard.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    size: 16, color: AppTheme.textPrimary),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isWish ? Icons.favorite : Icons.favorite_border,
                    color: isWish ? AppTheme.neonPink : AppTheme.textMuted,
                    size: 18,
                  ),
                ),
                onPressed: () => wishlist.toggle(product),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'product-${product.id}',
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppTheme.bgCard,
                        child: const Icon(Icons.gamepad,
                            color: AppTheme.textMuted, size: 80),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60, // <--- (2) Reducido de 80 a 60
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [AppTheme.bgPrimary, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), // <--- (3) Padding reducido
              child: Column(
                mainAxisSize: MainAxisSize.min, // <--- (4) Añadir mainAxisSize.min
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Badges ───────────────────────────────────────
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      NeonBadge(text: product.platform, color: AppTheme.neonBlue),
                      NeonBadge(text: product.category, color: AppTheme.neonPurple),
                      if (product.isNew)
                        const NeonBadge(text: 'NUEVO', color: AppTheme.neonGreen),
                    ],
                  ),
                  const SizedBox(height: 6),

                  Text(
                    product.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // ── Rating ───────────────────────────────────────
                  Row(children: [
                    RatingBarIndicator(
                      rating: product.rating,
                      itemBuilder: (_, __) =>
                          const Icon(Icons.star, color: Color(0xFFFFB800)),
                      itemCount: 5,
                      itemSize: 15,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${product.rating}',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${product.reviewCount} reseñas)',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),

                  // ── Precio ───────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PriceDisplay(
                        price: product.price,
                        originalPrice: product.originalPrice,
                        fontSize: 16, 
                      ),
                      const Spacer(),
                      if (product.hasDiscount)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.neonPink.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppTheme.neonPink.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            '-${product.discountPercent.toInt()}%',
                            style: const TextStyle(
                              color: AppTheme.neonPink,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ── Stock ─────────────────────────────────────────
                  _stockIndicator(product),

                  const SizedBox(height: 10),
                  const Divider(color: AppTheme.borderColor),
                  const SizedBox(height: 10),

                  // ── Descripción ───────────────────────────────────
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12, // <--- (6) Reducido de 13 a 12
                      height: 1.4,
                    ),
                  ),

                  // ── Tags ─────────────────────────────────────────
                  if (product.tags.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: product.tags
                          .map((t) => Chip(
                                label: Text(
                                  t,
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                                backgroundColor: AppTheme.bgCardLight,
                                side: const BorderSide(
                                    color: AppTheme.borderColor),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ))
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 14),

                  // ── Cantidad ──────────────────────────────────────
                  Row(children: [
                    const Text(
                      'Cantidad:',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _quantitySelector(product),
                  ]),

                  const SizedBox(height: 14),

                  // ── Botón agregar ─────────────────────────────────
                  GestureDetector(
                    onTap: () => _addToCart(product),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12), // <--- (7) Reducido de 14 a 12
                      decoration: neonButtonDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            inCart
                                ? Icons.shopping_cart
                                : Icons.add_shopping_cart,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            inCart
                                ? 'Actualizar carrito'
                                : 'Agregar al carrito',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Relacionados ──────────────────────────────────
                  if (related.isNotEmpty) ...[
                    const Text(
                      'Productos relacionados',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 360, // <--- (8) Aumentado de 310 a 360
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: related.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) => SizedBox(
                          width: 170,
                          child: ProductCard(product: related[i]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stockIndicator(Product product) => Row(children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: product.stock > 5
                ? AppTheme.neonGreen
                : product.stock > 0
                    ? AppTheme.neonOrange
                    : AppTheme.neonPink,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          product.stock > 5
              ? 'En stock (${product.stock} disponibles)'
              : product.stock > 0
                  ? '¡Solo quedan ${product.stock}!'
                  : 'Agotado',
          style: TextStyle(
            color: product.stock > 5
                ? AppTheme.neonGreen
                : product.stock > 0
                    ? AppTheme.neonOrange
                    : AppTheme.neonPink,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ]);

  Widget _quantitySelector(Product product) => Container(
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Row(children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 18),
            color: AppTheme.textSecondary,
            onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$_quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 18),
            color: AppTheme.neonPurple,
            onPressed: _quantity < product.stock
                ? () => setState(() => _quantity++)
                : null,
          ),
        ]),
      );
}