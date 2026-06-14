// lib/pages/history_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rentify_demo/services/app_state.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  static const Color primaryBlue = Color(0xFF0066FF);

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final orders = app.orders;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: primaryBlue,
          elevation: 0,
          centerTitle: true,
          title: const Text('Riwayat Peminjaman',
              style: TextStyle(color: Colors.white)),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
        ),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                'Belum ada riwayat',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ================= HISTORY LIST =================
                ...orders.map((o) {
                  // Menghitung tanggal dan waktu kembali
                  final returnDateTime = o.date.add(Duration(days: o.days));

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            o.product.image,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.circle,
                                      size: 8, color: Colors.green),
                                  SizedBox(width: 6),
                                  Text(
                                    'Sedang dipinjam',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                o.product.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),

                              // TANGGAL SEWA (Sudah ditambah jam)
                              Text(
                                'Tanggal sewa\n${DateFormat('d/M/yyyy').format(o.date)} - ${DateFormat.Hm().format(o.date)}',
                                style: const TextStyle(fontSize: 12),
                              ),

                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: primaryBlue,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'SAMPAI DENGAN',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),

                              // TANGGAL KEMBALI
                              Text(
                                'Tanggal kembali\n${DateFormat('d/M/yyyy').format(returnDateTime)} - ${DateFormat.Hm().format(returnDateTime)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 6),
                              Text(
                                'Rp ${o.totalPrice}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
    );
  }
}