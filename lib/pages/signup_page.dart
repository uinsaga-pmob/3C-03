// lib/pages/signup_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import 'dashboard_page.dart';

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
    final app = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(20),
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
          ElevatedButton(onPressed: () {
            final username = _phone.text.trim();
            final pass = _pass.text.trim();
            if (username.isEmpty || pass.isEmpty) {
              setState(() => _error = 'Isi semua field');
              return;
            }
            final ok = app.register(username, pass);
            if (ok) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPage()));
            } else {
              setState(() => _error = 'User sudah ada');
            }
          }, child: const Text('Sign up')),
          if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: const TextStyle(color: Colors.red))),
        ]),
      ),
    );
  }
}
