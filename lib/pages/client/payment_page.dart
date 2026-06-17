// lib/pages/client/payment_page.dart
import 'dart:io';
import 'package:flutter/material.dart';

// Koneksi ke SQLite dan Model baru milik kelompokmu
import '../../data/database_helper.dart';
import '../../models/products_model.dart';
import 'voucher_page.dart';
import 'payment_options_page.dart';

class PaymentPage extends StatefulWidget {
  final ProductModel product;
  final int days;
  
  const PaymentPage({super.key, required this.product, required this.days});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  static const primaryBlue = Color(0xFF0066FF);

  String selectedVoucher = '';
  String selectedPayment = 'e-Wallet';

  @override
  Widget build(BuildContext context) {
    final total = widget.product.price * widget.days;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      // ================= APP BAR =================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: primaryBlue,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
          title: const Text('PAYMENT', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Detail Barang", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),

            card(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: widget.product.imageUrl.startsWith('http')
                        ? Image.network(widget.product.imageUrl, width: 70, height: 70, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 70))
                        : Image.file(File(widget.product.imageUrl), width: 70, height: 70, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 70)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('Durasi: ${widget.days} Hari', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Text(
                    'Rp ${widget.product.price.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: primaryBlue),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text("Metode & Promo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),

            card(
              child: listButton(
                icon: Icons.confirmation_number_outlined,
                title: 'Voucher Rental',
                subtitle: selectedVoucher.isEmpty ? 'Gunakan voucher biar lebih hemat' : selectedVoucher,
                onTap: () async {
                  final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const VoucherPage()));
                  if (res != null) setState(() => selectedVoucher = res);
                },
              ),
            ),
            const SizedBox(height: 12),

            card(
              child: listButton(
                icon: Icons.payment_outlined,
                title: 'Metode Pembayaran',
                subtitle: selectedPayment,
                onTap: () async {
                  final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentOptionsPage()));
                  if (res != null) setState(() => selectedPayment = res);
                },
              ),
            ),

            const SizedBox(height: 20),
            const Text("Ringkasan Biaya", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),

            card(
              child: Column(
                children: [
                  summaryRow('Harga Sewa (${widget.days} hari)', 'Rp ${total.toStringAsFixed(0)}'),
                  summaryRow('Biaya Admin', 'Rp 2.000'),
                  const Divider(),
                  summaryRow('Total Pembayaran', 'Rp ${(total + 2000).toStringAsFixed(0)}', bold: true),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ================= BUTTON CONFIRM / BAYAR NYATA KE SQLITE =================
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () async {
                  final Map<String, dynamic> orderBaru = {
                    'id': DateTime.now().millisecondsSinceEpoch.toString(), 
                    'productId': widget.product.id,
                    // 'productName': widget.product.name,
                    // 'days': widget.days,
                    'totalPrice': total + 2000,
                    // 'date': DateTime.now().toString().split(' ')[0], 
                  };

                  final db = await DatabaseHelper.database;
                  int hasil = await db.insert('orders', orderBaru);

                  if (!mounted) return;

                  if (hasil > 0) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: const Row(
                          children: [
                            Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
                            SizedBox(width: 10),
                            Text('Sewa Berhasil!', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        content: const Text('Transaksi rentalmu telah berhasil disimpan ke database. Silakan cek di tab Riwayat.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (!ctx.mounted) return;
                              Navigator.pop(ctx); // Menutup pop-up dialog sukses
                              
                              if (!context.mounted) return;
                              // FIX NAVIGASI AMAN: Mundur kembali dan mengembalikan nilai true agar halaman katalog disegarkan otomatis
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('OK, Siap!', style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gagal memproses pembayaran ke database SQLite.')),
                    );
                  }
                },
                child: const Text(
                  'Bayar & Konfirmasi Sekarang',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget card({required Widget child}) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: child,
      );

  Widget summaryRow(String l, String r, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l, style: TextStyle(color: bold ? Colors.black : Colors.grey.shade700, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
            Text(r, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: bold ? primaryBlue : Colors.black)),
          ],
        ),
      );

  Widget listButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) =>
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: primaryBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: primaryBlue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
        onTap: onTap,
      );
}