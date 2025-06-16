// Purpose: UI for the final step: Reviewing and confirming the order.
import 'package:flutter/material.dart';
import '../../widgets/common/primary_button.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hardcoded data for UI layout purposes
    const String pickupAddress = "123 Main Street, Apt 4B\nNew York, NY 10001";
    const String pickupTime = "Tomorrow, Jun 17, 2025\n2:00 PM - 4:00 PM";
    const String deliveryAddress = "Same as pickup address";

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Order Summary"),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSection(
                  context,
                  title: "Pickup Details",
                  icon: Icons.location_on_outlined,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Pickup Address",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text(pickupAddress),
                      const SizedBox(height: 16),
                      const Text("Pickup Date & Time",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text(pickupTime),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: "Delivery Details",
                  icon: Icons.home_outlined,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Delivery Address",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text(deliveryAddress),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSection(context,
                    title: "Selected Items",
                    icon: Icons.checkroom_outlined,
                    content: const ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text("Suits"),
                      subtitle: Text("Qty: 1 • Press only"),
                      trailing: Text("\$14.00",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    )),
                const SizedBox(height: 16),
                _buildPriceBreakdown(context),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: PrimaryButton(
              text: "Confirm Pickup",
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for each section card
  Widget _buildSection(BuildContext context,
      {required String title,
      required IconData icon,
      required Widget content}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 8),
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                TextButton(onPressed: () {}, child: const Text("Edit")),
              ],
            ),
            const Divider(height: 24),
            content,
          ],
        ),
      ),
    );
  }

  // Helper widget for the price breakdown
  Widget _buildPriceBreakdown(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price Breakdown",
                style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 24),
            _buildPriceRow(context, label: "1x Suit", price: "\$12.00"),
            _buildPriceRow(context, label: "Press only", price: "\$2.00"),
            _buildPriceRow(context,
                label: "Pickup & Delivery", price: "\$3.99"),
            _buildPriceRow(context, label: "Tax", price: "\$1.44"),
            const Divider(height: 24),
            _buildPriceRow(context,
                label: "Total", price: "\$19.43", isTotal: true),
          ],
        ),
      ),
    );
  }

  // Helper widget for a single row in the price breakdown
  Widget _buildPriceRow(BuildContext context,
      {required String label, required String price, bool isTotal = false}) {
    final style = isTotal
        ? Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(price, style: style),
        ],
      ),
    );
  }
}
