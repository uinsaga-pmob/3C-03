import 'package:flutter/material.dart';

class PaymentOptionsPage extends StatelessWidget {
  const PaymentOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'PAYMENT OPTIONS',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Your Payment options!',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            paymentTile(
              context,
              title: 'Kredit/Debit',
              icon: Icons.credit_card,
            ),
            paymentTile(
              context,
              title: 'Transfer Bank',
              icon: Icons.account_balance,
            ),
            paymentTile(
              context,
              title: 'e-Wallet',
              icon: Icons.account_balance_wallet,
            ),
            paymentTile(
              context,
              title: 'COD',
              subtitle: 'Cash on Delivery',
              icon: Icons.payments,
            ),
            paymentTile(
              context,
              title: 'QR Code',
              icon: Icons.qr_code,
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentTile(
    BuildContext context, {
    required String title,
    String? subtitle,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, title),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.blue),
              minimumSize: const Size(60, 30),
              padding: EdgeInsets.zero,
            ),
            child: const Text(
              'PILIH',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
