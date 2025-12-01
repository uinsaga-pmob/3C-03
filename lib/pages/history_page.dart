// lib/pages/history_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final orders = app.orders;
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Peminjaman')),
      body: orders.isEmpty
        ? const Center(child: Text('Belum ada riwayat'))
        : ListView.builder(itemCount: orders.length, itemBuilder: (c,i) {
          final o = orders[i];
          return ListTile(
            leading: Image.asset(o.product.image, width: 56),
            title: Text(o.product.title),
            subtitle: Text('${o.days} hari • ${DateFormat.yMd().add_jm().format(o.date)}'),
            trailing: Text('Rp ${o.totalPrice}'),
          );
        }),
    );
  }
}
