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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          // ── SliverAppBar con Hero image — FASE 8.2 ───────────────
          SliverAppBar(
            expandedHeight: 320,
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
                  // Hero animation — misma tag que en ProductCard
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
                  // Gradient fade al fondo
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Badges ───────────────────────────────────────
                  Row(children: [
                    NeonBadge(text: product.platform, color: AppTheme.neonBlue),
                    const SizedBox(width: 8),
                    NeonBadge(
                        text: product.category, color: AppTheme.neonPurple),
                    if (product.isNew) ...[
                      const SizedBox(width: 8),
                      const NeonBadge(text: 'NUEVO', color: AppTheme.neonGreen),
                    ],
                  ]),
                  const SizedBox(height: 10),

                  Text(product.name,
                      style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),

                  // ── Rating ───────────────────────────────────────
                  Row(children: [
                    RatingBarIndicator(
                      rating: product.rating,
                      itemBuilder: (_, __) =>
                          const Icon(Icons.star, color: Color(0xFFFFB800)),
                      itemCount: 5,
                      itemSize: 16,
                    ),
                    const SizedBox(width: 8),
                    Text('${product.rating}',
                        style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(width: 4),
                    Text('(${product.reviewCount} reseñas)',
                        style: const TextStyle(
                            color: AppTheme.textMuted, fontSize: 12)),
                  ]),
                  const SizedBox(height: 14),

                  // ── Precio ───────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PriceDisplay(
                          price: product.price,
                          originalPrice: product.originalPrice,
                          fontSize: 24),
                      const Spacer(),
                      if (product.hasDiscount)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.neonPink.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color:
                                    AppTheme.neonPink.withValues(alpha: 0.4)),
                          ),
                          child: Text('-${product.discountPercent.toInt()}%',
                              style: const TextStyle(
                                  color: AppTheme.neonPink,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16)),
                        ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Stock ─────────────────────────────────────────
                  _stockIndicator(product),

                  const SizedBox(height: 16),
                  const Divider(color: AppTheme.borderColor),
                  const SizedBox(height: 14),

                  // ── Descripción ───────────────────────────────────
                  const Text('Descripción',
                      style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(product.description,
                      style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                          height: 1.6)),

                  // ── Tags como Chips ───────────────────────────────
                  if (product.tags.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: product.tags
                          .map((t) => Chip(
                                label: Text(t,
                                    style: const TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontSize: 12)),
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

                  const SizedBox(height: 20),

                  // ── Selector de cantidad — FASE 4 ─────────────────
                  Row(children: [
                    const Text('Cantidad:',
                        style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 16),
                    _quantitySelector(product),
                  ]),

                  const SizedBox(height: 20),

                  // ── Agregar al carrito ────────────────────────────
                  GestureDetector(
                    onTap: () => _addToCart(product),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: neonButtonDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              inCart
                                  ? Icons.shopping_cart
                                  : Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 20),
                          const SizedBox(width: 8),
                          Text(
                              inCart
                                  ? 'Actualizar carrito'
                                  : 'Agregar al carrito',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Relacionados ──────────────────────────────────
                  if (related.isNotEmpty) ...[
                    const Text('Productos relacionados',
                        style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 310,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: related.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) => SizedBox(
                            width: 170,
                            child: ProductCard(product: related[i])),
                      ),
                    ),
                    const SizedBox(height: 40),
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
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ]);

  Widget _quantitySelector(Product product) => Container(
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Row(children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 18),
            color: AppTheme.textSecondary,
            onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
          ),
          SizedBox(
            width: 32,
            child: Text('$_quantity',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
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
