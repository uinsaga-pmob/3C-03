import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/user_model.dart';
import '../models/products_model.dart';
import '../models/orders_model.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    String path = p.join(await getDatabasesPath(), 'rentify.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            name TEXT,
            email TEXT,
            phone INTEGER,
            password TEXT,
            role TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE products (
            id TEXT PRIMARY KEY,
            name TEXT,
            price REAL,
            imageUrl TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE orders (
            id TEXT PRIMARY KEY,
            userId TEXT,
            productId TEXT,
            rentalStartDate TEXT,
            rentalEndDate TEXT,
            totalPrice INTEGER,
            status TEXT,
            FOREIGN KEY (userId) REFERENCES users(id),
            FOREIGN KEY (productId) REFERENCES products(id)
          )
      ''');
      },
    );
  }

  // CRUD PRODUCT
  static Future<int> insertProduct(ProductModel product) async {
    final db = await database;
    return await db.insert('products', product.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateProduct(ProductModel product) async {
    final db = await database;
    return await db.update('products', product.toJson(),
        where: 'id = ?', whereArgs: [product.id]);
  }

  static Future<int> deleteProduct(String id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // SIGNUP
  static Future<int> registUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // LOGIN
  static Future<UserModel?> loginUser(String identity, String password) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      // Mencari yang (email cocok ATAU phone cocok) DAN password-nya benar
      where: '(email = ? OR phone = ?) AND password = ?',
      whereArgs: [identity, identity, password],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    } else {
      return null;
    }
  }
}
