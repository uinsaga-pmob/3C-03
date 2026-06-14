// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/app_state.dart';
import '../../widgets/product_card.dart';
import 'product_detail_page.dart';
import 'history_page.dart';
import 'profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _index = 0;
  String _keyword = '';

  static const Color primaryBlue = Color(0xFF0066FF);

  @override
  Widget build(BuildContext context) {
    // ===== PROVIDER =====
    final app = Provider.of<AppState>(context);

    // ===== FILTER PRODUK =====
    final products = app.products.where((p) {
      return p.title.toLowerCase().contains(_keyword.toLowerCase());
    }).toList();

    // ======================================================
    // ===================== TABS ===========================
    // ======================================================
    final List<Widget> tabs = [
      // ================= HOME =================
      Column(
        children: [
          // ===== HEADER =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
            decoration: const BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cari Barang\nKesukaanmu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // ===== SEARCH =====
                TextField(
                  onChanged: (v) {
                    setState(() => _keyword = v);
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.25),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ===== GRID PRODUK =====
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: products.isEmpty
                  ? const Center(
                      child: Text(
                        'Produk tidak ditemukan',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemBuilder: (context, i) {
                        final p = products[i];
                        return ProductCard(
                          product: p,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailPage(product: p),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),

      // ================= HISTORY =================
      const HistoryPage(),

      // ================= PROFILE =================
      const ProfilePage(),
    ];

    // ======================================================
    // ===================== UI =============================
    // ======================================================
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: tabs[_index],
      ),

      // ===== BOTTOM NAV =====
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) {
          setState(() => _index = i);
        },
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Katalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
