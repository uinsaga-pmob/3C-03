// lib/pages/client/profile_page.dart
import 'package:flutter/material.dart';
import 'login_page.dart'; // Mengimpor Halaman Login Anda

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ================= HEADER AKUN =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60, // Menyesuaikan area notch tanpa tombol back dummy
              left: 20,
              right: 20,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF0066FF), // Menyamakan warna biru utama RENTIFY
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: const [
                // Avatar Pengguna
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF0066FF),
                  ),
                ),

                SizedBox(height: 14),

                // Nama User Dinamis / Static Statis Sesuai Mockup Temanmu
                Text(
                  "WISNU JAYA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "client@rentify.com",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ================= LAYOUT MENU ITEM =================
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero, // Menghapus padding default bawaan ListView
              children: [
                menuItem(
                  icon: Icons.person_outline_rounded,
                  title: "Pengaturan Akun",
                  onTap: () {},
                ),
                menuItem(
                  icon: Icons.notifications_none_rounded,
                  title: "Pengaturan Notifikasi",
                  onTap: () {},
                ),
                menuItem(
                  icon: Icons.star_border_rounded,
                  title: "Rating Aplikasi",
                  onTap: () {},
                ),
                menuItem(
                  icon: Icons.info_outline_rounded,
                  title: "Tentang RENTIFY",
                  onTap: () {},
                ),
                menuItem(
                  icon: Icons.help_outline_rounded,
                  title: "Pusat Bantuan",
                  onTap: () {},
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(),
                ),

                // ================= MENU KELUAR / LOGOUT AMAN =================
                menuItem(
                  icon: Icons.logout_rounded,
                  title: "Keluar Akun",
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: () {
                    // Membersihkan tumpukan halaman root dan kembali ke LoginPage
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= COMPONENT WIDGET MENU =================
  Widget menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF0066FF),
    Color textColor = Colors.black,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1), // Bebas dari warning deprecated
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}