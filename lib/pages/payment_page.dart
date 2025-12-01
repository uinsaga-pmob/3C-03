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
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.product.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Durasi: ${widget.days} hari'),
          const SizedBox(height: 8),
          Text('Total: Rp $total', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text('Choose payment method:'),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: method,
            items: const [
              DropdownMenuItem(value: 'Kredit/Debit', child: Text('Kredit/Debit')),
              DropdownMenuItem(value: 'Transfer Bank', child: Text('Transfer Bank')),
              DropdownMenuItem(value: 'e-Wallet', child: Text('e-Wallet')),
              DropdownMenuItem(value: 'COD', child: Text('COD')),
            ],
            onChanged: (v) => setState(() { if (v!=null) method = v; }),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(onPressed: () {
              final order = app.rentProduct(widget.product, widget.days);
              // simple confirmation
              showDialog(context: context, builder: (_) => AlertDialog(
                title: const Text('Berhasil'),
                content: Text('Order ID: ${order.id}\nTotal: Rp ${order.totalPrice}'),
                actions: [
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }, child: const Text('OK'))
                ],
              ));
            }, child: const Text('Bayar / Konfirmasi')),
          ),
        ]),
      ),
    );
  }
}
