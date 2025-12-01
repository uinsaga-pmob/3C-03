// lib/models/product.dart
class Product {
  final String id;
  final String title;
  final String category;
  final String image;
  final int pricePerDay; // in IDR (for demo)

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.image,
    required this.pricePerDay,
  });
}
