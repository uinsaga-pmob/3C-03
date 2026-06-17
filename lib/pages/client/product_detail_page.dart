// lib/pages/client/product_detail_page.dart
import 'dart:io';
import 'package:flutter/material.dart';

// Import model baru milik kelompokmu
import '../../models/products_model.dart';
import 'payment_page.dart';

class ProductDetailPage extends StatefulWidget {
  // FIX: Mengubah tipe parameter menjadi ProductModel
  final ProductModel product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int days = 1;
  static const Color primaryBlue = Color(0xFF0066FF);
  static const Color textDark = Color(0xFF0A1931);

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, color: textDark)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: textDark),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== DISPLAY GAMBAR (Mendukung URL & File Lokal HP) =====
              Center(
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: p.imageUrl.startsWith('http')
                        ? Image.network(p.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 80, color: Colors.grey))
                        : Image.file(File(p.imageUrl), fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 80, color: Colors.grey)),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ===== INFO PRODUK =====
              Text(
                p.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textDark),
              ),
              const SizedBox(height: 8),
              Text(
                'Rp ${p.price.toStringAsFixed(0)} / hari',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryBlue),
              ),
              const SizedBox(height: 16),
              
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Deskripsi Barang',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark),
              ),
              const SizedBox(height: 8),
              Text(
                'Barang sewaan berkualitas tinggi dari RENTIFY. Kondisi prima, siap pakai, dan dijamin terawat untuk menunjang kebutuhan harian atau acaramu.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
              ),
              const SizedBox(height: 24),
              
              const Divider(),
              const SizedBox(height: 16),

              // ===== COUNTER JUMLAH HARI SEWA =====
              const Center(
                child: Text(
                  'Durasi Sewa',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (days > 1) days--;
                        });
                      },
                      icon: const Icon(Icons.remove, color: primaryBlue),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '$days Hari',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                    child: IconButton(
                      onPressed: () {
                        setState(() => days++);
                      },
                      icon: const Icon(Icons.add, color: primaryBlue),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),

              // ===== TOTAL HARGA & TOMBOL AJUKAN SEWA =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Biaya', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      Text(
                        'Rp ${(p.price * days).toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textDark),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Oper data produk SQLite beserta hari sewa ke halaman pembayaran kelompokmu
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaymentPage(product: p, days: days),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Lanjut ke Pembayaran',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}