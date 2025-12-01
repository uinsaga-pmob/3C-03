// lib/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Akun')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          ListTile(title: Text('User: ${app.currentUser ?? '-'}')),
          const Divider(),
          ListTile(leading: const Icon(Icons.settings), title: const Text('Pengaturan Notifikasi')),
          ListTile(leading: const Icon(Icons.help), title: const Text('Help Center')),
          const Spacer(),
          ElevatedButton(onPressed: () {
            app.logout();
            Navigator.popUntil(context, (route) => route.isFirst);
          }, child: const Text('Logout')),
        ]),
      ),
    );
  }
}
