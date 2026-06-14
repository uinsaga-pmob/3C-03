import 'package:flutter/material.dart';

class VoucherPage extends StatelessWidget {
  const VoucherPage({super.key});

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
          'VOUCHER',
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
              'Choose Your Voucher!',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            voucherTile(
              context,
              title: 'Discount 5%',
              subtitle: 'Min. sewa 3 hari',
              expired: 'Hingga 05.11.2025',
            ),
            voucherTile(
              context,
              title: 'Discount 2%',
              subtitle: 'Pengguna baru',
              expired: 'Hingga 05.11.2025',
            ),
            voucherTile(
              context,
              title: 'Discount 3%',
              subtitle: 'Min. sewa 2 item',
              expired: 'Hingga 05.11.2025',
            ),
          ],
        ),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.percent,
              color: Colors.white,
              size: 28,
            ),
          ),
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  expired,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, title),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.blue),
              minimumSize: const Size(60, 32),
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
