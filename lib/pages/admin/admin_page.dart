// lib/pages/admin/admin_page.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/product.dart';
import '../../services/app_state.dart';
import 'package:rentify_demo/pages/client/login_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // =========================
  // CONTROLLER
  // =========================

  final _titleCtrl    = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _imageCtrl    = TextEditingController();
  final _priceCtrl    = TextEditingController();
  final picker        = ImagePicker();

  String searchQuery = '';

  // -- Calendar state --
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay           = DateTime.now();
  DateTime? _selectedDay;

  // =========================
  // TEMA WARNA
  // =========================

  static const _primary   = Color(0xFF1A56FF);
  static const _surface   = Color(0xFFF0F4FF);
  static const _cardBg    = Colors.white;
  static const _accent1   = Color(0xFFFF6B35);
  static const _accent2   = Color(0xFF00C896);
  static const _textDark  = Color(0xFF0D1B4B);
  static const _textMuted = Color(0xFF8896B3);

  // =========================
  // DATA DUMMY ORDER & USER
  // =========================

  final List<Map<String, dynamic>> _orders = [
    {'id': 'ORD-001', 'user': 'Budi Santoso',    'product': 'Tenda Dome',     'tanggal': '10 Mei 2025', 'durasi': '3 hari', 'total': 'Rp 450.000', 'status': 'Selesai'},
    {'id': 'ORD-002', 'user': 'Sari Dewi',        'product': 'Sleeping Bag',   'tanggal': '12 Mei 2025', 'durasi': '2 hari', 'total': 'Rp 160.000', 'status': 'Aktif'},
    {'id': 'ORD-003', 'user': 'Andi Pratama',     'product': 'Carrier 60L',    'tanggal': '14 Mei 2025', 'durasi': '5 hari', 'total': 'Rp 375.000', 'status': 'Aktif'},
    {'id': 'ORD-004', 'user': 'Rina Wulandari',   'product': 'Matras Gulung',  'tanggal': '15 Mei 2025', 'durasi': '1 hari', 'total': 'Rp 50.000',  'status': 'Pending'},
    {'id': 'ORD-005', 'user': 'Dian Kurniawan',   'product': 'Tenda Dome',     'tanggal': '16 Mei 2025', 'durasi': '4 hari', 'total': 'Rp 600.000', 'status': 'Selesai'},
    {'id': 'ORD-006', 'user': 'Mega Lestari',     'product': 'Kompor Portable','tanggal': '17 Mei 2025', 'durasi': '2 hari', 'total': 'Rp 100.000', 'status': 'Pending'},
    {'id': 'ORD-007', 'usyer': 'Hendra Wijaya',    'product': 'Headlamp',       'tanggal': '18 Mei 2025', 'durasi': '3 hari', 'total': 'Rp 90.000',  'status': 'Aktif'},
    {'id': 'ORD-008', 'user': 'Yuni Astuti',      'product': 'Carrier 60L',    'tanggal': '19 Mei 2025', 'durasi': '7 hari', 'total': 'Rp 525.000', 'status': 'Selesai'},
    {'id': 'ORD-009', 'user': 'Rizky Fauzan',     'product': 'Raincoat',       'tanggal': '20 Mei 2025', 'durasi': '2 hari', 'total': 'Rp 80.000',  'status': 'Aktif'},
    {'id': 'ORD-010', 'user': 'Laila Nurul',      'product': 'Sleeping Bag',   'tanggal': '20 Mei 2025', 'durasi': '3 hari', 'total': 'Rp 240.000', 'status': 'Pending'},
    {'id': 'ORD-011', 'user': 'Doni Saputra',     'product': 'Trekking Pole',  'tanggal': '21 Mei 2025', 'durasi': '2 hari', 'total': 'Rp 70.000',  'status': 'Aktif'},
    {'id': 'ORD-012', 'user': 'Fitri Handayani',  'product': 'Matras Gulung',  'tanggal': '21 Mei 2025', 'durasi': '4 hari', 'total': 'Rp 200.000', 'status': 'Selesai'},
    {'id': 'ORD-013', 'user': 'Bagas Nugroho',    'product': 'Tenda Dome',     'tanggal': '22 Mei 2025', 'durasi': '6 hari', 'total': 'Rp 900.000', 'status': 'Aktif'},
    {'id': 'ORD-014', 'user': 'Citra Permata',    'product': 'Kompor Portable','tanggal': '23 Mei 2025', 'durasi': '1 hari', 'total': 'Rp 50.000',  'status': 'Pending'},
    {'id': 'ORD-015', 'user': 'Wahyu Saputra',    'product': 'Carrier 60L',    'tanggal': '24 Mei 2025', 'durasi': '3 hari', 'total': 'Rp 225.000', 'status': 'Selesai'},
  ];

  final List<Map<String, dynamic>> _users = [
    {'nama': 'Budi Santoso',   'email': 'budi@email.com',   'hp': '081234567890', 'bergabung': '1 Jan 2024',  'order': 3, 'status': 'Aktif'},
    {'nama': 'Sari Dewi',      'email': 'sari@email.com',   'hp': '082345678901', 'bergabung': '5 Feb 2024',  'order': 1, 'status': 'Aktif'},
    {'nama': 'Andi Pratama',   'email': 'andi@email.com',   'hp': '083456789012', 'bergabung': '10 Mar 2024', 'order': 2, 'status': 'Aktif'},
    {'nama': 'Rina Wulandari', 'email': 'rina@email.com',   'hp': '084567890123', 'bergabung': '15 Apr 2024', 'order': 1, 'status': 'Nonaktif'},
    {'nama': 'Dian Kurniawan', 'email': 'dian@email.com',   'hp': '085678901234', 'bergabung': '20 Apr 2024', 'order': 2, 'status': 'Aktif'},
    {'nama': 'Mega Lestari',   'email': 'mega@email.com',   'hp': '086789012345', 'bergabung': '1 Mei 2024',  'order': 1, 'status': 'Aktif'},
    {'nama': 'Hendra Wijaya',  'email': 'hendra@email.com', 'hp': '087890123456', 'bergabung': '10 Mei 2024', 'order': 2, 'status': 'Aktif'},
    {'nama': 'Yuni Astuti',    'email': 'yuni@email.com',   'hp': '088901234567', 'bergabung': '20 Mei 2024', 'order': 3, 'status': 'Nonaktif'},
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _categoryCtrl.dispose();
    _imageCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  // =========================
  // PICK IMAGE
  // =========================

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageCtrl.text = picked.path);
    }
  }

  // =========================
  // LOGOUT / KEMBALI KE LOGIN
  // =========================

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Keluar',
          style: TextStyle(fontWeight: FontWeight.w800, color: _textDark),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari halaman admin?',
          style: TextStyle(color: _textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: _textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.of(context).pop();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false,
              );
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // =========================
  // HELPER: BOTTOM SHEET WRAPPER
  // =========================

  void _showDetailSheet({required String title, required Widget body}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: _textDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.close_rounded, color: _textMuted, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFEEF1F8)),
              // Body
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(20),
                  children: [body],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // DETAIL: PRODUK
  // =========================

  void _showDetailProduk(List<Product> products) {
    _showDetailSheet(
      title: 'Detail Produk',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _miniStatCard('Total Produk', '${products.length}', Icons.inventory_2_rounded, _primary),
              const SizedBox(width: 12),
              _miniStatCard(
                'Kategori',
                '${products.map((p) => p.category).toSet().length}',
                Icons.category_rounded,
                _accent2,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Semua Produk',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _textDark),
          ),
          const SizedBox(height: 12),
          if (products.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('Belum ada produk', style: TextStyle(color: _textMuted)),
              ),
            )
          else
            ...products.map((p) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildProductImage(p.image, size: 56),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, color: _textDark, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(p.category,
                            style: const TextStyle(color: _textMuted, fontSize: 13)),
                      ],
                    ),
                  ),
                  Text(
                    'Rp ${p.pricePerDay}/hr',
                    style: const TextStyle(
                        color: _primary, fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  // =========================
  // DETAIL: ORDER
  // =========================

  void _showDetailOrder() {
    final selesai = _orders.where((o) => o['status'] == 'Selesai').length;
    final aktif   = _orders.where((o) => o['status'] == 'Aktif').length;
    final pending = _orders.where((o) => o['status'] == 'Pending').length;

    _showDetailSheet(
      title: 'Detail Order',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _miniStatCard('Selesai', '$selesai', Icons.check_circle_rounded, _accent2),
              const SizedBox(width: 10),
              _miniStatCard('Aktif', '$aktif', Icons.loop_rounded, _primary),
              const SizedBox(width: 10),
              _miniStatCard('Pending', '$pending', Icons.hourglass_top_rounded, _accent1),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Semua Order',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _textDark),
          ),
          const SizedBox(height: 12),
          ..._orders.map((o) {
            final Color statusColor;
            final Color statusBg;
            switch (o['status']) {
              case 'Selesai':
                statusColor = _accent2;
                statusBg    = const Color(0xFFE6FBF5);
                break;
              case 'Aktif':
                statusColor = _primary;
                statusBg    = const Color(0xFFE8EEFF);
                break;
              default:
                statusColor = _accent1;
                statusBg    = const Color(0xFFFFF0EA);
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(o['id'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, color: _textDark, fontSize: 14)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(o['status'],
                            style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _orderRow(Icons.person_rounded,         o['user']),
                  const SizedBox(height: 4),
                  _orderRow(Icons.inventory_2_rounded,    o['product']),
                  const SizedBox(height: 4),
                  _orderRow(Icons.calendar_today_rounded, '${o['tanggal']} · ${o['durasi']}'),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(o['total'],
                        style: const TextStyle(
                            color: _primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _orderRow(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 14, color: _textMuted),
      const SizedBox(width: 6),
      Expanded(
        child: Text(text,
            style: const TextStyle(color: _textMuted, fontSize: 13),
            overflow: TextOverflow.ellipsis),
      ),
    ],
  );

  // =========================
  // DETAIL: USER
  // =========================

  void _showDetailUser() {
    final aktif    = _users.where((u) => u['status'] == 'Aktif').length;
    final nonaktif = _users.where((u) => u['status'] == 'Nonaktif').length;

    _showDetailSheet(
      title: 'Detail User',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _miniStatCard('Aktif',    '$aktif',    Icons.person_rounded,     _accent2),
              const SizedBox(width: 12),
              _miniStatCard('Nonaktif', '$nonaktif', Icons.person_off_rounded, _accent1),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Semua User',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _textDark),
          ),
          const SizedBox(height: 12),
          ..._users.map((u) {
            final bool isAktif = u['status'] == 'Aktif';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isAktif
                            ? [_primary, const Color(0xFF5B8AFF)]
                            : [_textMuted, const Color(0xFFBCC5D8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        (u['nama'] as String).substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(u['nama'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: _textDark,
                                      fontSize: 15),
                                  overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isAktif
                                    ? const Color(0xFFE6FBF5)
                                    : const Color(0xFFFFF0EA),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(u['status'],
                                  style: TextStyle(
                                      color: isAktif ? _accent2 : _accent1,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(u['email'],
                            style: const TextStyle(color: _textMuted, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text('${u['hp']} · ${u['order']} order',
                            style: const TextStyle(color: _textMuted, fontSize: 12)),
                        const SizedBox(height: 2),
                        Text('Bergabung: ${u['bergabung']}',
                            style: const TextStyle(color: _textMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // =========================
  // MINI STAT CARD
  // =========================

  Widget _miniStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800, color: color)),
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: _textMuted, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // DASHBOARD CARD (clickable)
  // =========================

  Widget _dashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.75)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(height: 14),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white54, size: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // INPUT FIELD HELPER
  // =========================

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: _textDark, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _textMuted, fontSize: 14),
        prefixIcon: Icon(icon, color: _primary, size: 20),
        filled: true,
        fillColor: _surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primary, width: 1.5),
        ),
      ),
    );
  }

  // =========================
  // HELPER: PRODUCT IMAGE
  // =========================

  Widget _buildProductImage(String imagePath, {double size = 88}) {
    final isFile = imagePath.startsWith('/') || imagePath.startsWith('file://');
    if (isFile && File(imagePath).existsSync()) {
      return Image.file(
        File(imagePath),
        width: size, height: size, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagePlaceholder(size),
      );
    }
    // Coba sebagai asset
    return Image.asset(
      imagePath,
      width: size, height: size, fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _imagePlaceholder(size),
    );
  }

  Widget _imagePlaceholder(double size) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      color: _surface,
      borderRadius: BorderRadius.circular(size * 0.2),
    ),
    child: const Icon(Icons.image_not_supported_rounded, color: _textMuted, size: 30),
  );

  // =========================
  // FORM PRODUK (Add / Edit)
  // =========================

  void _showProductForm({Product? product}) {
    if (product != null) {
      _titleCtrl.text    = product.title;
      _categoryCtrl.text = product.category;
      _imageCtrl.text    = product.image;
      _priceCtrl.text    = product.pricePerDay.toString();
    } else {
      _titleCtrl.clear();
      _categoryCtrl.clear();
      _imageCtrl.clear();
      _priceCtrl.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          product == null ? Icons.add_box_rounded : Icons.edit_rounded,
                          color: _primary, size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        product == null ? 'Tambah Produk' : 'Edit Produk',
                        style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800,
                          color: _textDark, letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildField(
                    controller: _titleCtrl,
                    label: 'Nama Produk',
                    icon: Icons.inventory_2_outlined,
                  ),
                  const SizedBox(height: 14),
                  _buildField(
                    controller: _categoryCtrl,
                    label: 'Kategori',
                    icon: Icons.category_outlined,
                  ),
                  const SizedBox(height: 14),
                  _buildField(
                    controller: _imageCtrl,
                    label: 'Path Gambar',
                    icon: Icons.image_outlined,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity, height: 48,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () async {
                        await pickImage();
                        // Rebuild sheet setelah pick
                        (ctx as Element).markNeedsBuild();
                      },
                      icon: const Icon(Icons.upload_rounded, color: _primary),
                      label: const Text('Upload Gambar',
                          style: TextStyle(
                              color: _primary, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildField(
                    controller: _priceCtrl,
                    label: 'Harga per Hari (Rp)',
                    icon: Icons.payments_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity, height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary, elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        // Validasi sederhana
                        final title    = _titleCtrl.text.trim();
                        final category = _categoryCtrl.text.trim();
                        final image    = _imageCtrl.text.trim();
                        final price    = int.tryParse(_priceCtrl.text.trim()) ?? 0;

                        if (title.isEmpty || category.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Nama produk dan kategori wajib diisi'),
                              backgroundColor: _accent1,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                          return;
                        }

                        final app = Provider.of<AppState>(context, listen: false);
                        final newProduct = Product(
                          id:          product?.id ??
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          title:       title,
                          category:    category,
                          image:       image,
                          pricePerDay: price,
                        );

                        if (product == null) {
                          app.addProduct(newProduct);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Produk berhasil ditambahkan'),
                              backgroundColor: _accent2,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        } else {
                          app.updateProduct(newProduct);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Produk berhasil diperbarui'),
                              backgroundColor: _primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        product == null ? 'Tambah Produk' : 'Update Produk',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // =========================
  // KONFIRMASI HAPUS
  // =========================

  void _confirmDelete(String productId, String productName, AppState app) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Hapus Produk',
          style: TextStyle(fontWeight: FontWeight.w800, color: _textDark),
        ),
        content: Text(
          'Hapus "$productName" dari daftar produk?',
          style: const TextStyle(color: _textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: _textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            onPressed: () {
              app.deleteProduct(productId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Produk berhasil dihapus'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: const Text('Hapus',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    final app      = Provider.of<AppState>(context);
    final products = app.products.where((p) {
      return p.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
             p.category.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: _surface,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _primary,
        elevation: 8,
        onPressed: () => _showProductForm(),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Tambah Produk',
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =========================
              // HEADER + TOMBOL KEMBALI
              // =========================
              Container(
                padding: const EdgeInsets.fromLTRB(16, 20, 24, 20),
                child: Row(
                  children: [
                    // Tombol Kembali ke Login
                    GestureDetector(
                      onTap: _logout,
                      child: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: _primary, size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Judul
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Admin Dashboard',
                            style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w900,
                              color: _textDark, letterSpacing: -0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Kelola produk rental',
                            style: TextStyle(
                              color: _textMuted, fontSize: 13, fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Admin avatar
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_primary, Color(0xFF5B8AFF)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _primary.withOpacity(0.35),
                            blurRadius: 10, offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: Colors.white, size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // =========================
              // SEARCH BAR
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  style: const TextStyle(color: _textDark),
                  decoration: InputDecoration(
                    hintText: 'Cari produk atau kategori...',
                    hintStyle: const TextStyle(color: _textMuted),
                    prefixIcon: const Icon(Icons.search_rounded, color: _primary),
                    suffixIcon: searchQuery.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              setState(() => searchQuery = '');
                            },
                            child: const Icon(Icons.close_rounded, color: _textMuted),
                          )
                        : null,
                    filled: true,
                    fillColor: _cardBg,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: _primary, width: 1.5),
                    ),
                  ),
                  onChanged: (value) => setState(() => searchQuery = value),
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // DASHBOARD CARDS (clickable)
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    _dashboardCard(
                      title: 'Produk',
                      value: '${app.products.length}',
                      icon: Icons.inventory_2_rounded,
                      color: _primary,
                      onTap: () => _showDetailProduk(app.products),
                    ),
                    _dashboardCard(
                      title: 'Order',
                      value: '${_orders.length}',
                      icon: Icons.shopping_bag_rounded,
                      color: _accent1,
                      onTap: _showDetailOrder,
                    ),
                    _dashboardCard(
                      title: 'User',
                      value: '${_users.length}',
                      icon: Icons.people_rounded,
                      color: _accent2,
                      onTap: _showDetailUser,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // KALENDER
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20, offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 12),
                        child: Text('Kalender Sewa',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: _textDark)),
                      ),
                      TableCalendar(
                        firstDay: DateTime.utc(2020),
                        lastDay: DateTime.utc(2030),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay  = focusedDay;
                          });
                        },
                        onFormatChanged: (format) =>
                            setState(() => _calendarFormat = format),
                        onPageChanged: (focusedDay) =>
                            setState(() => _focusedDay = focusedDay),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: _primary.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          todayTextStyle: const TextStyle(
                              color: _primary, fontWeight: FontWeight.w700),
                          selectedDecoration: const BoxDecoration(
                              color: _primary, shape: BoxShape.circle),
                          selectedTextStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                          weekendTextStyle: const TextStyle(color: _accent1),
                          outsideDaysVisible: false,
                        ),
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: true,
                          titleCentered: true,
                          formatButtonDecoration: BoxDecoration(
                            color: _primary,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12)),
                          ),
                          formatButtonTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                          titleTextStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: _textDark),
                          leftChevronIcon:
                              Icon(Icons.chevron_left_rounded, color: _textDark),
                          rightChevronIcon:
                              Icon(Icons.chevron_right_rounded, color: _textDark),
                        ),
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                              color: _textMuted,
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                          weekendStyle: TextStyle(
                              color: _accent1,
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // SECTION LABEL
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Daftar Produk',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: _textDark)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${products.length} item',
                        style: const TextStyle(
                            color: _primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // =========================
              // PRODUCT LIST
              // =========================
              products.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 60, horizontal: 40),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.inventory_2_outlined,
                                size: 64,
                                color: _textMuted.withOpacity(0.35)),
                            const SizedBox(height: 16),
                            Text(
                              searchQuery.isEmpty
                                  ? 'Belum ada produk'
                                  : 'Produk tidak ditemukan',
                              style: const TextStyle(
                                  color: _textMuted,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            if (searchQuery.isEmpty) ...[
                              const SizedBox(height: 8),
                              const Text(
                                'Tekan tombol + untuk menambahkan produk',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: _textMuted, fontSize: 13),
                              ),
                            ],
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 4),
                      itemCount: products.length,
                      itemBuilder: (context, i) {
                        final p = products[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: _cardBg,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                // Gambar produk
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: _buildProductImage(p.image),
                                ),
                                const SizedBox(width: 14),
                                // Info produk
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(p.title,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: _textDark),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color:
                                              _primary.withOpacity(0.08),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(p.category,
                                            style: const TextStyle(
                                                color: _primary,
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeight.w600)),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Rp ${p.pricePerDay}/hari',
                                        style: const TextStyle(
                                            color: _primary,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                // Tombol aksi
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: _primary.withOpacity(0.08),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: IconButton(
                                        onPressed: () =>
                                            _showProductForm(product: p),
                                        icon: const Icon(
                                            Icons.edit_rounded,
                                            color: _primary,
                                            size: 20),
                                        tooltip: 'Edit',
                                        constraints: const BoxConstraints(
                                            minWidth: 40, minHeight: 40),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.red.withOpacity(0.08),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: IconButton(
                                        onPressed: () => _confirmDelete(
                                            p.id, p.title, app),
                                        icon: const Icon(
                                            Icons.delete_rounded,
                                            color: Colors.red,
                                            size: 20),
                                        tooltip: 'Hapus',
                                        constraints: const BoxConstraints(
                                            minWidth: 40, minHeight: 40),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}