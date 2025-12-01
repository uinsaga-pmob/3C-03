// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import 'signup_page.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // header
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                  color: Color(0xFF0066FF),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(110)),
                ),
                padding: const EdgeInsets.only(left: 28, top: 30),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  Text('RENTIFY', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('Cari Barang\nKesukaanmu', style: TextStyle(color: Colors.white70)),
                ]),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('LOGIN', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Text("Don't have an account? "),
                    GestureDetector(onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPage()));
                    }, child: const Text('sign up', style: TextStyle(color: Colors.purple))),
                  ]),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
                    child: TextField(controller: _phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(border: InputBorder.none, hintText: '+62')),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
                    child: TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(border: InputBorder.none, hintText: 'Password')),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 140,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                        onPressed: () {
                          final phone = _phoneCtrl.text.trim();
                          final pass = _passCtrl.text.trim();
                          // for demo we treat phone as username
                          final ok = app.login(phone.isEmpty ? 'admin' : phone, pass.isEmpty ? '12345' : pass);
                          if (ok) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPage()));
                          } else {
                            setState(() => _error = 'Username atau password salah (demo)');
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(child: Text('-OR-')),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    _social('assets/google.png'),
                    const SizedBox(width: 24),
                    _social('assets/facebook.png'),
                  ]),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _social(String asset) {
    return Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)]), child: Image.asset(asset, width: 28));
  }
}
