// lib/pages/client/dashboard_page.dart
import 'dart:io';
import 'package:flutter/material.dart';

// Koneksi ke SQLite dan Model Kelompokmu
import '../../data/database_helper.dart';
import '../../models/products_model.dart';
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

  // Fungsi mengambil produk secara real-time dari database SQLite
  Future<List<ProductModel>> _getDaftarProduk() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    
    List<ProductModel> listSemua = maps.map((e) => ProductModel.fromJson(e)).toList();

    // Fitur filter pencarian live jika user mengetik di search bar
    if (_keyword.isNotEmpty) {
      return listSemua
          .where((p) => p.name.toLowerCase().contains(_keyword.toLowerCase()))
          .toList();
    }
    return listSemua;
  }

  @override
  Widget build(BuildContext context) {
    // ======================================================
    // ===================== LIST TABS ======================
    // ======================================================
    final List<Widget> tabs = [
      // ================= TAB 0: KATALOG HOME =================
      Column(
        children: [
          // ===== HEADER & SEARCH BAR =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
            decoration: const BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cari Barang\nKesukaanmu',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (v) {
                    setState(() => _keyword = v); // Refresh grid saat mengetik keyword
                  },
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Cari barang rental...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: primaryBlue),
                    filled: true,
                    fillColor: Colors.white,
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

          // ===== GRID PRODUK ASLI DARI SQLITE =====
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder<List<ProductModel>>(
                future: _getDaftarProduk(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Produk tidak ditemukan atau gudang kosong.', style: TextStyle(color: Colors.grey)),
                    );
                  }

                  final products = snapshot.data!;

                  return GridView.builder(
                    itemCount: products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, i) {
                      final p = products[i];
                      
                      // Custom Card bawaan tanpa dependensi widget card eksternal yang usang
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailPage(product: p),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 3))
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tampilan Gambar Fleksibel
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                    child: p.imageUrl.startsWith('http')
                                        ? Image.network(p.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, color: Colors.grey))
                                        : Image.file(File(p.imageUrl), fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, color: Colors.grey)),
                                  ),
                                ),
                              ),
                              // Label Info Nama & Harga
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Text('Rp ${p.price.toStringAsFixed(0)}/hari', style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 13)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // ================= TAB 1: HISTORY =================
      const HistoryPage(),

      // ================= TAB 2: PROFILE =================
      const ProfilePage(),
    ];

    // ======================================================
    // ================= CORE SCAFFOLD UI ===================
    // ======================================================
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: tabs[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) {
          setState(() => _index = i);
        },
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Katalog'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}