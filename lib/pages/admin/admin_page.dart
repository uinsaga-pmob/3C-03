// lib/pages/admin/admin_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';

// Sambungkan ke data lokal dan model milikmu
import '../../../data/database_helper.dart';
import '../../../models/products_model.dart';
import '../client/login_page.dart';

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
  final _imageCtrl    = TextEditingController();
  final _priceCtrl    = TextEditingController();
  final picker        = ImagePicker();

  String searchQuery = '';

  // -- Calendar state --
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay           = DateTime.now();
  DateTime? _selectedDay;

  // File gambar lokal jika user memilih opsi upload foto dari HP
  File? _selectedImageFile;

  // =========================
  // TEMA WARNA
  // =========================
  static const _primary   = Color(0xFF1A56FF);
  static const _surface   = Color(0xFFF0F4FF);
  static const _textDark  = Color(0xFF0A1931);

  @override
  void dispose() {
    _titleCtrl.dispose();
    _imageCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  // Fungsi pick image bawaan timmu
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
        _imageCtrl.text = pickedFile.path; // Simpan path gambar lokal ke controller
      });
    }
  }

  // ==========================================
  // LOGIC DATABASE SQLITE (TAMBAH & HAPUS)
  // ==========================================
  
  // Ambil semua produk dari SQLite dan filter berdasarkan pencarian
  Future<List<ProductModel>> _getDaftarProduk() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    
    // Ubah data Map dari database menjadi Objek ProductModel
    List<ProductModel> listSemua = maps.map((e) => ProductModel.fromJson(e)).toList();

    // Jalankan filter pencarian jika kolom search diisi
    if (searchQuery.isNotEmpty) {
      return listSemua
          .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    return listSemua;
  }

  // Jalankan fungsi simpan produk baru ke SQLite
  void _saveProduct() async {
    if (_titleCtrl.text.isEmpty || _priceCtrl.text.isEmpty || _imageCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field (termasuk gambar) wajib diisi!')),
      );
      return;
    }

    final price = double.tryParse(_priceCtrl.text) ?? 0.0;
    
    // Bungkus ke objek ProductModel kamu
    final produkBaru = ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _titleCtrl.text.trim(),
      price: price,
      imageUrl: _imageCtrl.text.trim(),
    );

    int hasil = await DatabaseHelper.insertProduct(produkBaru);

    // FIX EROR NOMOR 3: Guard check murni menggunakan State mounted lokal
    if (!mounted) return;

    if (hasil > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Barang berhasil ditambahkan ke SQLite!')),
      );
      // Bersihkan form
      _titleCtrl.clear();
      _priceCtrl.clear();
      _imageCtrl.clear();
      setState(() {
        _selectedImageFile = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan ke database')),
      );
    }
  }

  // Jalankan fungsi hapus produk dari SQLite
  void _confirmDelete(String id, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Barang?'),
        content: Text('Apakah kamu yakin ingin menghapus "$title"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.deleteProduct(id);
              if (!mounted) return;
              Navigator.pop(ctx);
              setState(() {}); // Refresh list barang di layar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('"$title" telah dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Rentify Admin', style: TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // SECTION 1: FORM INPUT BARANG BARU
              // ==========================================
              const Text('Manajemen Barang Sewa', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _textDark)),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tambah Item Baru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _primary)),
                    const SizedBox(height: 14),
                    
                    // FIX EROR NOMOR 1: Menghapus 'fillButtonLabel' yang typo kemarin
                    TextField(controller: _titleCtrl, decoration: InputDecoration(hintText: 'Nama Barang', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), prefixIcon: const Icon(Icons.shopping_bag_outlined, color: _primary))),
                    const SizedBox(height: 12),
                    
                    TextField(controller: _priceCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(hintText: 'Harga Sewa / Hari', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), prefixIcon: const Icon(Icons.payments_outlined, color: _primary))),
                    const SizedBox(height: 12),
                    
                    // Input Gambar / Upload Foto
                    Row(
                      children: [
                        Expanded(
                          child: TextField(controller: _imageCtrl, decoration: InputDecoration(hintText: 'URL Gambar atau Path Foto', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), prefixIcon: const Icon(Icons.image_outlined, color: _primary))),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.add_photo_alternate_rounded, color: _primary, size: 28),
                          tooltip: 'Ambil dari Galeri',
                        )
                      ],
                    ),
                    
                    // Preview Gambar kecil jika ada
                    if (_selectedImageFile != null) ...[
                      const SizedBox(height: 10),
                      ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(_selectedImageFile!, height: 80, width: 80, fit: BoxFit.cover)),
                    ],
                    
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _saveProduct,
                        style: ElevatedButton.styleFrom(backgroundColor: _primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                        icon: const Icon(Icons.save_rounded, color: Colors.white),
                        label: const Text('Simpan ke Database', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ==========================================
              // SECTION 2: KALENDER MONITORING (DESAIN TIMMU)
              // ==========================================
              const Text('Kalender Monitoring Sewa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                ),
              ),

              const SizedBox(height: 32),

              // ==========================================
              // SECTION 3: SEARCH BAR & DAFTAR PRODUK SQLITE
              // ==========================================
              // FIX EROR NOMOR 2: Diubah menjadi spaceBetween yang valid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Daftar Produk Aktif', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                  IconButton(onPressed: () => setState(() {}), icon: const Icon(Icons.refresh_rounded, color: _primary)),
                ],
              ),
              const SizedBox(height: 12),
              
              // Kolom Search
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  onChanged: (val) => setState(() => searchQuery = val),
                  decoration: const InputDecoration(border: InputBorder.none, hintText: 'Cari nama barang...', prefixIcon: Icon(Icons.search)),
                ),
              ),
              const SizedBox(height: 16),

              // Penayangan List Data menggunakan FutureBuilder SQLite
              FutureBuilder<List<ProductModel>>(
                future: _getDaftarProduk(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(searchQuery.isEmpty ? 'Belum ada barang di database.' : 'Barang tidak ditemukan.', style: TextStyle(color: Colors.grey.shade500)),
                      ),
                    );
                  }

                  final dataBarang = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dataBarang.length,
                    itemBuilder: (context, index) {
                      final p = dataBarang[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade100),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: p.imageUrl.startsWith('http')
                                  ? Image.network(p.imageUrl, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 60, color: Colors.grey))
                                  : Image.file(File(p.imageUrl), width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 60, color: Colors.grey)),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _textDark)),
                                  const SizedBox(height: 4),
                                  Text('Rp ${p.price.toStringAsFixed(0)} / hari', style: const TextStyle(color: _primary, fontWeight: FontWeight.w600, fontSize: 13)),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
                              child: IconButton(
                                onPressed: () => _confirmDelete(p.id, p.name),
                                icon: const Icon(Icons.delete_rounded, color: Colors.red, size: 20),
                                tooltip: 'Hapus',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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