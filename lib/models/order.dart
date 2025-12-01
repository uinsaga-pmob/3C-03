// lib/models/order.dart
import 'product.dart';

class Order {
  final String id;
  final Product product;
  final int days;
  final DateTime date;
  final int totalPrice;

  Order({
    required this.id,
    required this.product,
    required this.days,
    required this.date,
    required this.totalPrice,
  });
}
