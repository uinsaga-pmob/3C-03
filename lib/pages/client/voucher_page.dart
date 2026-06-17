// lib/pages/client/voucher_page.dart
import 'package:flutter/material.dart';

class VoucherPage extends StatelessWidget {
  const VoucherPage({super.key});

  static const Color primaryBlue = Color(0xFF0066FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: primaryBlue,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'VOUCHER RENTAL',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Pilih Voucher Menarik Untukmu!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0A1931)),
          ),
          const SizedBox(height: 16),
          voucherTile(
            context,
            title: 'Diskon Akhir Bulan 5%',
            subtitle: 'Minimal sewa 3 hari berturut-turut',
            expired: 'Berlaku hingga akhir bulan ini',
          ),
          voucherTile(
            context,
            title: 'Potongan Pengguna Baru 2%',
            subtitle: 'Khusus untuk transaksi pertama kamu',
            expired: 'Tanpa minimum transaksi',
          ),
          voucherTile(
            context,
            title: 'Promo Bundling 3%',
            subtitle: 'Minimal sewa lebih dari 1 item sekaligus',
            expired: 'Berlaku setiap hari weekend',
          ),
        ],
      ),
    );
  }

  Widget voucherTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String expired,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.confirmation_number_outlined,
              color: primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0A1931)),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 6),
                Text(
                  expired,
                  style: TextStyle(fontSize: 11, color: Colors.amber.shade800, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, title),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Gunakan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}