// lib/main.dart
import 'package:flutter/material.dart';
import 'pages/client/login_page.dart';

void main() {
  // Memastikan inisialisasi SQLite berjalan lancar sebelum UI dirender
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rentify Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // Membuat tampilan visual button & card lebih modern
      ),
      home: const LoginPage(),
    );
  }
}