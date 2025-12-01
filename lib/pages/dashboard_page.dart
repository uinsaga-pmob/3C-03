// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';
import 'history_page.dart';
import 'profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final tabs = [
      // katalog
      Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: app.products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.72, mainAxisSpacing: 12, crossAxisSpacing: 12),
          itemBuilder: (context, i) {
            final p = app.products[i];
            return ProductCard(product: p, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: p))));
          },
        ),
      ),
      // history
      const Center(child: Text('History page')),
      // profile
      const Center(child: Text('Profile page')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('KATALOG'),
        actions: [
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage())), icon: const Icon(Icons.history)),
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())), icon: const Icon(Icons.person)),
        ],
      ),
      body: tabs[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Katalog'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}
