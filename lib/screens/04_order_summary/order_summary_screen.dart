// Purpose: UI for the final step: Reviewing and confirming the order.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../widgets/common/primary_button.dart';
import '../../state/order_provider.dart';

class OrderSummaryScreen extends StatelessWidget {
  final VoidCallback onBack;

  const OrderSummaryScreen({Key? key, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        // Format the data from the provider
        final pickupAddress = order.pickupAddress != null
            ? '${order.pickupAddress!.street}${(order.pickupAddress!.apartment?.isNotEmpty ?? false) ? ', ${order.pickupAddress!.apartment}' : ''}\n${order.pickupAddress!.city}, ${order.pickupAddress!.zipCode}'
            : 'Not selected';

        final deliveryAddress = order.deliveryAddress != null
            ? (order.deliveryAddress == order.pickupAddress
                ? 'Same as pickup address'
                : '${order.deliveryAddress!.street}${(order.deliveryAddress!.apartment?.isNotEmpty ?? false) ? ', ${order.deliveryAddress!.apartment}' : ''}\n${order.deliveryAddress!.city}, ${order.deliveryAddress!.zipCode}')
            : 'Not selected';

        final pickupTime = order.scheduleSlot != null
            ? '${order.scheduleSlot!.startTime.format(context)} - ${order.scheduleSlot!.endTime.format(context)}'
            : 'Not selected';

        // Calculate total from selected services
        double subtotal = 0;
        for (var item in order.selectedItems) {
          subtotal += item.price * item.quantity;
        }
        final delivery = 3.99;
        final tax = subtotal * 0.08; // 8% tax
        final total = subtotal + delivery + tax;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBack,
                ),
                title: Text(localizations.order_summary_title),
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
                          Text("Pickup Address",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(pickupAddress,
                              style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 16),
                          Text("Pickup Date & Time",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(pickupTime,
                              style: Theme.of(context).textTheme.bodyLarge),
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
                          Text("Delivery Address",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(deliveryAddress,
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      context,
                      title: "Selected Items",
                      icon: Icons.checkroom_outlined,
                      content: order.selectedItems.isEmpty
                          ? Text("No items selected",
                              style: Theme.of(context).textTheme.bodyLarge)
                          : Column(
                              children: order.selectedItems
                                  .map(
                                    (item) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(item.name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                Text("Qty: ${item.quantity}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium),
                                              ],
                                            ),
                                          ),
                                          Text(
                                              "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                    const SizedBox(height: 16),
                    _buildPriceBreakdown(
                        context, subtotal, delivery, tax, total),
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
      },
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
  Widget _buildPriceBreakdown(BuildContext context, double subtotal,
      double delivery, double tax, double total) {
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
            _buildPriceRow(context,
                label: "Subtotal", price: "\$${subtotal.toStringAsFixed(2)}"),
            _buildPriceRow(context,
                label: "Pickup & Delivery",
                price: "\$${delivery.toStringAsFixed(2)}"),
            _buildPriceRow(context,
                label: "Tax", price: "\$${tax.toStringAsFixed(2)}"),
            const Divider(height: 24),
            _buildPriceRow(context,
                label: "Total",
                price: "\$${total.toStringAsFixed(2)}",
                isTotal: true),
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
