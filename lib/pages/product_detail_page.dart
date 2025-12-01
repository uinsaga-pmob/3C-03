// lib/pages/product_detail_page.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'payment_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int days = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: AppBar(title: Text(p.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Image.asset(p.image, height: 220),
          const SizedBox(height: 12),
          Text('Kategori: ${p.category}'),
          const SizedBox(height: 8),
          Text('Rp ${p.pricePerDay} / hari', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(onPressed: () => setState(() { if (days>1) days--; }), icon: const Icon(Icons.remove)),
            Text('$days hari'),
            IconButton(onPressed: () => setState(() => days++), icon: const Icon(Icons.add)),
          ]),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () {
            // go to payment page with product and days
            Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentPage(product: p, days: days)));
          }, child: const Text('Chek')),
        ]),
      ),
    );
  }
}
