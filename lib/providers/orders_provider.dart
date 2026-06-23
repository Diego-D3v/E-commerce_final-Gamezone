import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/cart_item.dart';

class OrdersProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  List<Order> getOrdersByUser(String userId) =>
      _orders.where((o) => o.userId == userId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  Order placeOrder({
    required String userId,
    required List<CartItem> items,
    required double total,
    String address = 'Calle 45 #12-34, Bucaramanga',
  }) {
    final order = Order(
      id: 'GZ-${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      items: List.from(items),
      total: total,
      status: OrderStatus.processing,
      createdAt: DateTime.now(),
      address: address,
    );
    _orders.insert(0, order);
    notifyListeners();
    return order;
  }
}
