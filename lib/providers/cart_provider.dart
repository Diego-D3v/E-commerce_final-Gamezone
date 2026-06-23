import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  // Map<productId, CartItem> — estructura del taller
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items       => {..._items};
  List<CartItem>        get itemsList   => _items.values.toList();
  int                   get itemCount   => _items.values.fold(0, (s, i) => s + i.quantity);
  double                get totalPrice  => _items.values.fold(0, (s, i) => s + i.subtotal);
  double                get shipping    => totalPrice > 500000 ? 0 : 25000;
  double                get grandTotal  => totalPrice + shipping;

  bool contains(String productId) => _items.containsKey(productId);
  int quantityOf(String productId) => _items[productId]?.quantity ?? 0;

  void addProduct(Product product, {int quantity = 1}) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += quantity;
    } else {
      _items[product.id] = CartItem(product: product, quantity: quantity);
    }
    notifyListeners();
  }

  void removeOne(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity--;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void addOne(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity++;
      notifyListeners();
    }
  }

  void removeProduct(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() { _items.clear(); notifyListeners(); }
}
