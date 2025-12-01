<<<<<<< HEAD
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/app_state.dart';
import 'pages/login_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => AppState(), child: const MyApp())
  );
=======
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
>>>>>>> 76db26dae4eaf0f76c8e5e5dd383f215abbe76a0
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rentify Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
=======

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belajar Flutter Kelas ',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Halaman Utama", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Center(child: Text("Mulai Belajar Flutter")),
      ),
>>>>>>> 76db26dae4eaf0f76c8e5e5dd383f215abbe76a0
    );
  }
}
