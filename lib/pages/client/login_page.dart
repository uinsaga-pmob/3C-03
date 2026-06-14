import 'package:flutter/material.dart';
import '../admin/admin_page.dart';
import 'dashboard_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                  color: Color(0xFF0066FF),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(110),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 28,
                  top: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'RENTIFY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Cari Barang\nKesukaanmu',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignupPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'sign up',
                            style: TextStyle(color: Colors.purple),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Username
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _usernameCtrl,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Username',
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Password
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                        ),
                      ),
                    ),

                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],

                    const SizedBox(height: 20),

                    Center(
                      child: SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4E5CEE),
                          ),
                          onPressed: () {
                            final username =
                                _usernameCtrl.text.trim();
                            final password =
                                _passwordCtrl.text.trim();

                            // LOGIN ADMIN
                            if (username == "admin" &&
                                password == "12345") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const AdminPage(),
                                ),
                              );
                            }

                            // CLIENT
                            else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const DashboardPage(),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Center(
                      child: Text('- OR -'),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        _social('assets/google.png'),
                        const SizedBox(width: 24),
                        _social('assets/facebook.png'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _social(String asset) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
          ),
        ],
      ),
      child: Image.asset(
        asset,
        width: 28,
        errorBuilder: (_, __, ___) {
          return const Icon(Icons.image);
        },
      ),
    );
  }
}