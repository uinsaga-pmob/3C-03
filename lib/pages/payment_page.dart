// lib/pages/payment_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/app_state.dart';

class PaymentPage extends StatefulWidget {
  final Product product;
  final int days;
  const PaymentPage({super.key, required this.product, required this.days});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String method = 'Kredit/Debit';

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);
    final total = widget.product.pricePerDay * widget.days;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ===== Product Summary =====
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Durasi: ${widget.days} hari',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const Divider(height: 24),
                    Text(
                      'Total Pembayaran',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp $total',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// ===== Payment Method =====
            const Text(
              'Metode Pembayaran',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: method,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                        value: 'Kredit/Debit',
                        child: Text('Kredit / Debit')),
                    DropdownMenuItem(
                        value: 'Transfer Bank',
                        child: Text('Transfer Bank')),
                    DropdownMenuItem(
                        value: 'e-Wallet',
                        child: Text('e-Wallet')),
                    DropdownMenuItem(
                        value: 'COD', child: Text('COD')),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => method = v);
                    }
                  },
                ),
              ),
            ),

            const Spacer(),

            /// ===== Pay Button =====
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  final order =
                      app.rentProduct(widget.product, widget.days);

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Pembayaran Berhasil'),
                      content: Text(
                        'Order ID: ${order.id}\nTotal: Rp ${order.totalPrice}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  'Bayar Sekarang',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
