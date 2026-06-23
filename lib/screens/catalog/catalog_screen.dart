import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../data/product_data.dart';
import '../../models/product.dart';
import '../../widgets/common_widgets.dart';

class CatalogShell extends StatelessWidget {
  const CatalogShell({super.key});
  @override
  Widget build(BuildContext context) => const CatalogScreen();
}

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _searchCtrl = TextEditingController();
  String _selectedCategory = 'Todos';
  String _sortBy = 'Relevancia';

  final _sorts = ['Relevancia', 'Precio: menor', 'Precio: mayor', 'Calificación'];

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  // Lógica de filtro (FASE 3 — búsqueda y filtro)
  List<Product> get _filteredProducts {
    List<Product> result = kProducts;
    if (_searchCtrl.text.isNotEmpty) {
      result = searchProducts(_searchCtrl.text);
    }
    if (_selectedCategory != 'Todos') {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }
    switch (_sortBy) {
      case 'Precio: menor':  result = [...result]..sort((a, b) => a.price.compareTo(b.price)); break;
      case 'Precio: mayor':  result = [...result]..sort((a, b) => b.price.compareTo(a.price)); break;
      case 'Calificación':   result = [...result]..sort((a, b) => b.rating.compareTo(a.rating)); break;
      default: break;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final products   = _filteredProducts;
    final categories = kCategories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
        automaticallyImplyLeading: false,
        actions: [
          const CartBadge(),
          IconButton(
            icon: const Icon(Icons.swap_vert, color: AppTheme.neonPurple),
            onPressed: _showSortSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search bar ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: TextField(
              controller: _searchCtrl,
              style: const TextStyle(color: AppTheme.textPrimary),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar juegos, consolas...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppTheme.textMuted, size: 18),
                        onPressed: () { _searchCtrl.clear(); setState(() {}); },
                      )
                    : null,
              ),
            ),
          ),

          // ── Category FilterChips — FASE 3 ─────────────────────────
          const SizedBox(height: 10),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = categories[i];
                final selected = cat == _selectedCategory;
                return FilterChip(
                  label: Text(cat,
                    style: TextStyle(
                      color: selected ? Colors.white : AppTheme.textSecondary,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13,
                    )),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedCategory = cat),
                  selectedColor: AppTheme.neonPurple,
                  backgroundColor: AppTheme.bgCard,
                  checkmarkColor: Colors.white,
                  side: BorderSide(color: selected ? AppTheme.neonPurple : AppTheme.borderColor),
                  showCheckmark: false,
                );
              },
            ),
          ),

          // ── Results count ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: Row(
              children: [
                Text('${products.length} productos',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                const Spacer(),
                GestureDetector(
                  onTap: _showSortSheet,
                  child: Row(children: [
                    const Icon(Icons.swap_vert, color: AppTheme.neonPurple, size: 16),
                    const SizedBox(width: 4),
                    Text(_sortBy, style: const TextStyle(color: AppTheme.neonPurple, fontSize: 13, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ],
            ),
          ),

          // ── Grid ─────────────────────────────────────────────────
          Expanded(
            child: products.isEmpty
                ? EmptyState(
                    icon: Icons.search_off,
                    title: 'Sin resultados',
                    subtitle: 'No encontramos productos para tu búsqueda',
                    buttonLabel: 'Limpiar filtros',
                    onButton: () => setState(() {
                      _searchCtrl.clear();
                      _selectedCategory = 'Todos';
                      _sortBy = 'Relevancia';
                    }),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.52,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.length,
                    itemBuilder: (_, i) => ProductCard(product: products[i]),
                  ),
          ),
        ],
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgSecondary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ordenar por',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ..._sorts.map((s) => ListTile(
              title: Text(s, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15)),
              trailing: _sortBy == s ? const Icon(Icons.check_circle, color: AppTheme.neonPurple) : null,
              onTap: () { setState(() => _sortBy = s); Navigator.pop(context); },
            )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
