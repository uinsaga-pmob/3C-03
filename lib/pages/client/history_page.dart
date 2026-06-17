// lib/pages/client/history_page.dart
import 'package:flutter/material.dart';
import '../../data/database_helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  static const Color primaryBlue = Color(0xFF0066FF);

  // Fungsi untuk mengambil data riwayat sewa dari tabel orders SQLite
  Future<List<Map<String, dynamic>>> _getRiwayatSewa() async {
    final db = await DatabaseHelper.database;
    // Mengambil data order terbaru di posisi paling atas (DESC)
    return await db.query('orders', orderBy: 'id DESC');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: primaryBlue,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Riwayat Peminjaman',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading:
              false, // Biar tidak muncul tombol back otomatis di tab
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
        ),
      ),

      // ===== FUTUREBUILDER MEMBACA SQLITE =====
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getRiwayatSewa(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off_rounded,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada riwayat penyewaan.',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
            );
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final o = orders[index];

              // Parsing data dari database
              final String productName = o['productName'] ?? 'Barang Sewa';
              final int days = o['days'] ?? 1;
              final double totalPrice = (o['totalPrice'] ?? 0).toDouble();
              final String date = o['date'] ?? '-';

              return Container(
                // KODE YANG BENAR (Perbaikan):
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Ikon Representasi Barang Kontainer
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.assignment_turned_in_rounded,
                        color: primaryBlue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Detail Informasi Nota Order
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF0A1931),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tanggal Sewa: $date',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            'Durasi: $days Hari',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Badge Sisi Kanan (Total Harga & Status)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Berhasil',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rp ${totalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
