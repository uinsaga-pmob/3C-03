import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../services/app_state.dart';
import 'voucher_page.dart';
import 'payment_options_page.dart';

class PaymentPage extends StatefulWidget {
  final Product product;
  final int days;
  const PaymentPage({super.key, required this.product, required this.days});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  static const primaryBlue = Color(0xFF0066FF);

  String selectedVoucher = '';
  String selectedPayment = 'e-Wallet';

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);
    final total = widget.product.pricePerDay * widget.days;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      // ================= APP BAR =================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: primaryBlue,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
          title: const Text('PAYMENT',
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
        ),
      ),

      // ================= BODY =================
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          sectionTitle('Order Summary'),

          card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                rowText('Kategori Order', 'Kamera'),
                rowText('Jenis Order', widget.product.title),
                const Divider(),
                rowText('Name', 'Agung jaya'),
                rowText('No.HP', '0997767675877'),
                const Divider(),
                badge('Location'),
                rowText('From', 'Bendolgi, Juwangi, Jawa Tengah'),
                rowText('To', 'Pulutan, Temang, Jawa Timur'),
                const SizedBox(height: 12),
                badge('Time order'),
                rowText('Tanggal sewa', '15/9/2025'),
                rowText('Tanggal kembali', '16/9/2025'),
                rowText('Durasi', '${widget.days} hari'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          sectionTitle('Payment Summary'),
          card(
            child: Column(
              children: [
                summaryRow('Biaya sewa', 'Rp ${total - 7000000}'),
                summaryRow('Ongkir', 'Rp 7.000.000'),
                if (selectedVoucher.isNotEmpty)
                  summaryRow('Voucher', selectedVoucher),
                const Divider(),
                summaryRow('Total Payment', 'Rp $total', bold: true),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ================= VOUCHER =================
          listButton(
            icon: Icons.percent,
            title: 'Gunakan Voucher Sewa',
            subtitle: selectedVoucher.isEmpty
                ? 'Voucher gratis ongkir'
                : selectedVoucher,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VoucherPage()),
              );
              if (result != null) {
                setState(() => selectedVoucher = result);
              }
            },
          ),

          // ================= PAYMENT OPTIONS =================
          listButton(
            icon: Icons.account_balance_wallet,
            title: 'Payment Options',
            subtitle: selectedPayment,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaymentOptionsPage()),
              );
              if (result != null) {
                setState(() => selectedPayment = result);
              }
            },
          ),
        ],
      ),

      // ================= BOTTOM =================
      bottomNavigationBar: bottomBar(total, app),
    );
  }

  // ================= UI COMPONENT =================
  Widget bottomBar(int total, AppState app) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Total Payment',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('Rp $total',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                app.rentProduct(widget.product, widget.days);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Bayar'),
            )
          ],
        ),
      );

  Widget sectionTitle(String t) => Text(t,
      style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.bold));

  Widget badge(String t) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: primaryBlue, borderRadius: BorderRadius.circular(6)),
        child: Text(t,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white)),
      );

  Widget card({required Widget child}) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: child,
      );

  Widget rowText(String l, String r) => Row(
        children: [
          Expanded(child: Text(l, style: const TextStyle(color: Colors.grey))),
          Expanded(
              child:
                  Text(r, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      );

  Widget summaryRow(String l, String r, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l),
            Text(r,
                style: TextStyle(
                    fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      );

  Widget listButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) =>
      ListTile(
        leading: Icon(icon, color: primaryBlue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      );
}
