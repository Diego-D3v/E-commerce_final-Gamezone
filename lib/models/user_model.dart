import 'cart_item.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  UserModel copyWith({String? name, String? email, String? password}) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        createdAt: createdAt,
      );
}

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final String address;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.address,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:    return 'Pendiente';
      case OrderStatus.processing: return 'Procesando';
      case OrderStatus.shipped:    return 'Enviado';
      case OrderStatus.delivered:  return 'Entregado';
      case OrderStatus.cancelled:  return 'Cancelado';
    }
  }
}
