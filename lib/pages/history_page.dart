// lib/pages/history_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/app_state.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  static const Color primaryBlue = Color(0xFF0066FF);

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final orders = app.orders;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      // ================= APP BAR =================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: primaryBlue,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Riwayat Peminjaman',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
        ),
      ),

      // ================= BODY =================
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
                // ================= USER CARD =================
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: primaryBlue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Yoga',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '098867654433',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ================= HISTORY LIST =================
                ...orders.map((o) {
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
                        // ===== IMAGE =====
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

                        // ===== INFO =====
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Status
                              Row(
                                children: const [
                                  Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: Colors.green,
                                  ),
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

                              // Title
                              Text(
                                o.product.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // Tanggal sewa
                              Text(
                                'Tanggal sewa\n${DateFormat('d/M/yyyy').format(o.date)}',
                                style: const TextStyle(fontSize: 12),
                              ),

                              const SizedBox(height: 4),

                              // Badge sampai dengan
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
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

                              // Tanggal kembali
                              Text(
                                'Tanggal kembali\n${DateFormat('d/M/yyyy').format(o.date.add(Duration(days: o.days)))}',
                                style: const TextStyle(fontSize: 12),
                              ),

                              const SizedBox(height: 6),

                              // Harga
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
