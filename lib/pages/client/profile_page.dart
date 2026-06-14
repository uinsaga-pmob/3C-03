import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentify_demo/services/app_state.dart'; // Memastikan mengarah ke AppState Anda
import 'login_page.dart'; // Mengimpor Halaman Login Anda

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Memanggil state management jika ingin melakukan clear session saat logout
    final app = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ================= HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF0A5CFF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Avatar
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF0A5CFF),
                  ),
                ),

                const SizedBox(height: 10),

                // Name
                const Text(
                  "WISNU JAYA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ================= MENU =================
          Expanded(
            child: ListView(
              padding:
                  EdgeInsets.zero, // Menghapus padding default bawaan ListView
              children: [
                menuItem(
                  icon: Icons.person,
                  title: "Pengaturan Akun",
                  onTap: () {},
                ),
                menuItem(
                  icon: Icons.notifications,
                  title: "Pengaturan Notifikasi",
                  onTap: () {},
                ),
                menuItem(
                  icon: Icons.star,
                  title: "Rating",
                  onTap: () {},
                ),
                menuItem(
                  icon: Icons.info,
                  title: "About",
                  onTap: () {},
                ),
                menuItem(
                  icon: Icons.help,
                  title: "Help Center",
                  onTap: () {},
                ),

                // ================= MENU KELUAR / LOGOUT =================
                menuItem(
                  icon: Icons.logout,
                  title: "Keluar",
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: () {
                    // 1. (Opsional) Jalankan fungsi logout pada AppState jika tersedia
                    // app.logout();

                    // 2. Bersihkan tumpukan halaman dan arahkan ke LoginPage
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

  // ================= MENU ITEM WIDGET =================
  Widget menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF0A5CFF),
    Color textColor = Colors.black,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}