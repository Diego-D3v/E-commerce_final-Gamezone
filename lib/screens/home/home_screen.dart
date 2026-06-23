import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../data/product_data.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common_widgets.dart';

// Export alias para ShellRoute
class HomeShell extends StatelessWidget {
  const HomeShell({super.key});
  @override
  Widget build(BuildContext context) => const HomeScreen();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = false;

  // ── RefreshIndicator — resetea búsqueda/filtros (FASE 8.1) ────────
  Future<void> _onRefresh() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final featured = featuredProducts;
    final newItems = newProducts;

    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (b) => const LinearGradient(
              colors: [AppTheme.neonPurple, AppTheme.neonBlue]).createShader(b),
          child: const Text('GAMEZONE',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.textPrimary),
            onPressed: () => context.go('/catalog'),
          ),
          const CartBadge(),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        // FASE 8.1 — RefreshIndicator
        color: AppTheme.neonPurple,
        backgroundColor: AppTheme.bgCard,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Saludo ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Hola, ${auth.currentUser?.name.split(' ').first ?? 'Gamer'} 👾',
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 14)),
                    const Text('¿Qué vas a jugar hoy?',
                        style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── PageView de banners — FASE 8.3 ───────────────────
              const _BannerCarousel(),

              const SizedBox(height: 24),

              // ── Categorías ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  title: 'Categorías',
                  onSeeAll: () => context.go('/catalog'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: _categories
                      .map((cat) => GestureDetector(
                            onTap: () => context.go('/catalog'),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: (cat['color'] as Color)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: (cat['color'] as Color)
                                        .withValues(alpha: 0.4)),
                              ),
                              child: Row(children: [
                                Text(cat['icon'] as String,
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(width: 6),
                                Text(cat['label'] as String,
                                    style: TextStyle(
                                        color: cat['color'] as Color,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                              ]),
                            ),
                          ))
                      .toList(),
                ),
              ),

              const SizedBox(height: 24),

              // ── Destacados ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  title: 'Destacados',
                  subtitle: 'Los más populares del momento',
                  onSeeAll: () => context.go('/catalog'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 350, // ← altura aumentada de 340 a 370
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: featured.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => SizedBox(
                      width: 170, child: ProductCard(product: featured[i])),
                ),
              ),

              const SizedBox(height: 24),

              // ── Nuevos ────────────────────────────────────────────
              if (newItems.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'Nuevos lanzamientos',
                    subtitle: 'Recién llegados',
                    onSeeAll: () => context.go('/catalog'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 350, // ← altura aumentada de 340 a 370
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: newItems.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => SizedBox(
                        width: 170, child: ProductCard(product: newItems[i])),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static const _categories = [
    {'label': 'Consolas', 'icon': '🎮', 'color': AppTheme.neonPurple},
    {'label': 'Videojuegos', 'icon': '🕹️', 'color': AppTheme.neonBlue},
    {'label': 'Accesorios', 'icon': '🎧', 'color': AppTheme.neonGreen},
    {'label': 'PC Gaming', 'icon': '💻', 'color': AppTheme.neonOrange},
  ];
}

// ── PageView de banners ──────────────────────────────────────────────
class _BannerCarousel extends StatefulWidget {
  const _BannerCarousel();
  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  final PageController _controller = PageController();
  int _current = 0;

  static const _banners = [
    {
      'title': 'PS5 Nueva Gen',
      'subtitle': 'Hasta 15% de descuento',
      'tag': 'OFERTA',
      'image': 'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=800',
    },
    {
      'title': 'Accesorios Pro',
      'subtitle': 'Equípate para ganar',
      'tag': 'NUEVO',
      'image': 'https://images.unsplash.com/photo-1612287230202-1ff1d85d1bdf?w=800',
    },
    {
      'title': 'Juegos AAA 2025',
      'subtitle': 'Los mejores títulos',
      'tag': 'TOP',
      'image': 'https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AA24Ifje.img?w=768&h=432&m=6&x=236&y=72&s=673&d=188',
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 4));
      if (!mounted) return false;
      final next = (_current + 1) % _banners.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      return true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) {
              final b = _banners[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(b['image'] as String),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black.withValues(alpha: 0.7),
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NeonBadge(text: b['tag'] as String, color: Colors.white),
                        const SizedBox(height: 8),
                        Text(
                          b['title'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          b['subtitle'] as String,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              width: _current == i ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _current == i ? AppTheme.neonPurple : AppTheme.textMuted,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}