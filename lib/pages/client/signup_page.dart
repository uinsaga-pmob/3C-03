// lib/pages/client/signup_page.dart
import 'package:flutter/material.dart';
import '../../../data/database_helper.dart';
import '../../../models/user_model.dart';
import '../../pages/admin/admin_page.dart'; // Menuju ke folder admin

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _pass = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(children: [
            const Text('Create Account', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Already have an account? '),
              GestureDetector(onTap: () => Navigator.pop(context), child: const Text('sign in', style: TextStyle(color: Colors.purple))),
            ]),
            const SizedBox(height: 20),
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Email or phone', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final name = _name.text.trim();
                final username = _phone.text.trim();
                final pass = _pass.text.trim();
  
                if (name.isEmpty || username.isEmpty || pass.isEmpty) {
                  setState(() => _error = 'Isi semua field');
                  return;
                }
  
                String roleOtomatis = name.toLowerCase().contains('admin') ? 'admin' : 'client';
                final phoneInt = int.tryParse(username) ?? 0;
  
                UserModel userBaru = UserModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  email: username.contains('@') ? username : '$name@rentify.com',
                  phone: phoneInt,
                  password: pass,
                  role: roleOtomatis,
                );
  
                int hasil = await DatabaseHelper.registUser(userBaru);
  
                if (!mounted) return;
  
                if (hasil > 0) {
                  if (roleOtomatis == 'admin') {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminPage()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registrasi Client Berhasil! Silakan Login.')),
                    );
                    Navigator.pop(context);
                  }
                } else {
                  setState(() => _error = 'Gagal menyimpan akun ke database');
                }
              }, 
              child: const Text('Sign up'),
            ),
            if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: const TextStyle(color: Colors.red))),
          ]),
        ),
      ),
    );
  }
}