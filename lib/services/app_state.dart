// lib/services/app_state.dart
import 'package:flutter/material.dart';
import 'package:rentify_demo/pages/client/login_page.dart';
import '../models/product.dart';
import '../models/order.dart';
import 'dart:math';

class AppState with ChangeNotifier {
  String? _currentUser;
  final Map<String,String> _users = {}; // simple in-memory {username:password}
  final List<Product> _products = [];
  final List<Order> _orders = [];

  AppState() {
    // seed some products
    _products.addAll([
      Product(id: 'p1', title: 'DSLR 1500D KIT', category: 'Kamera', image: 'assets/products/product1.png', pricePerDay: 50000),
      Product(id: 'p2', title: 'iPhone 14 Pro Max', category: 'Handphone', image: 'assets/products/product2.png', pricePerDay: 150000),
      Product(id: 'p3', title: 'Lenovo LOQ', category: 'Laptop', image: 'assets/products/product3.png', pricePerDay: 80000),
      Product(id: 'p4', title: 'pS 5', category: 'Play station', image: 'assets/products/product4.png', pricePerDay: 90000),
    ]);
    // demo account
    _users['admin'] = '12345';
  }

  // getters
  String? get currentUser => _currentUser;
  List<Product> get products => List.unmodifiable(_products);
  List<Order> get orders => List.unmodifiable(_orders.where((o) => _currentUser != null));

  // auth
  bool login(String username, String password) {
    if (_users.containsKey(username) && _users[username] == password) {
      _currentUser = username;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool register(String username, String password) {
    if (_users.containsKey(username)) return false;
    _users[username] = password;
    _currentUser = username;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // order
  Order rentProduct(Product p, int days) {
    final total = p.pricePerDay * days;
    final order = Order(
      id: Random().nextInt(999999).toString(),
      product: p,
      days: days,
      date: DateTime.now(),
      totalPrice: total,
    );
    _orders.add(order);
    notifyListeners();
    return order;
  }
// =========================
// CRUD PRODUCT
// =========================

// CREATE
void addProduct(Product product) {

  _products.add(product);

  notifyListeners();
}

// UPDATE
void updateProduct(Product updatedProduct) {

  final index = _products.indexWhere(
    (p) => p.id == updatedProduct.id,
  );

  if (index != -1) {

    _products[index] = updatedProduct;

    notifyListeners();
  }
}

// DELETE
void deleteProduct(String id) {

  _products.removeWhere(
    (p) => p.id == id,
  );

  notifyListeners();
}

// ADMIN CHECK
bool get isAdmin =>
    _currentUser == 'admin';  
}
