// lib/pages/client/payment_options_page.dart
import 'package:flutter/material.dart';

class PaymentOptionsPage extends StatelessWidget {
  const PaymentOptionsPage({super.key});

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
            'METODE PEMBAYARAN',
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
            'Pilih Metode Pembayaran',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0A1931)),
          ),
          const SizedBox(height: 16),
          paymentTile(
            context,
            title: 'Kredit / Debit',
            subtitle: 'Visa, MasterCard, JCB',
            icon: Icons.credit_card_rounded,
          ),
          paymentTile(
            context,
            title: 'Transfer Bank (VA)',
            subtitle: 'BCA, Mandiri, BNI, BRI',
            icon: Icons.account_balance_rounded,
          ),
          paymentTile(
            context,
            title: 'e-Wallet',
            subtitle: 'GoPay, OVO, Dana, LinkAja',
            icon: Icons.account_balance_wallet_rounded,
          ),
          paymentTile(
            context,
            title: 'COD (Cash on Delivery)',
            subtitle: 'Bayar tunai di lokasi pengambilan',
            icon: Icons.payments_rounded,
          ),
          paymentTile(
            context,
            title: 'QRIS / QR Code',
            subtitle: 'Scan cepat menggunakan aplikasi bank/e-wallet',
            icon: Icons.qr_code_2_rounded,
          ),
        ],
      ),
    );
  }

  Widget paymentTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryBlue, size: 28),
          ),
          const SizedBox(width: 16),
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
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context, title),
            icon: const Icon(Icons.check_circle_outline_rounded, color: primaryBlue),
          ),
        ],
      ),
    );
  }
}