// Purpose: UI for the final step: Reviewing and confirming the order.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../widgets/common/primary_button.dart';
import '../../state/order_provider.dart';
import 'package:intl/intl.dart';

class OrderSummaryScreen extends StatelessWidget {
  final VoidCallback onBack;

  const OrderSummaryScreen({super.key, required this.onBack});

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

        final pickupDate = order.scheduleSlot != null
            ? DateFormat('EEEE, MMMM d').format(order.scheduleSlot!.date)
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
                    icon: const Icon(Icons.arrow_back), onPressed: onBack),
                title: Text(localizations.order_summary_title),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Pickup & Delivery Section ---
                    _buildSectionHeader(context,
                        icon: Icons.local_shipping_outlined,
                        title: "Pickup & Delivery"),
                    const SizedBox(height: 8),
                    _buildInfoCard(
                      children: [
                        _buildInfoRow(context,
                            label: "Pickup Address", value: pickupAddress),
                        const Divider(height: 24),
                        _buildInfoRow(context,
                            label: "Delivery Address", value: deliveryAddress),
                        const Divider(height: 24),
                        _buildInfoRow(context,
                            label: "Pickup Date", value: pickupDate),
                        const Divider(height: 24),
                        _buildInfoRow(context,
                            label: "Pickup Time", value: pickupTime),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- Order Details Section ---
                    _buildSectionHeader(context,
                        icon: Icons.list_alt_outlined, title: "Order Details"),
                    const SizedBox(height: 8),
                    _buildInfoCard(
                      children: [
                        if (order.selectedItems.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text("No items selected."),
                          )
                        else
                          ...order.selectedItems.map((item) => _buildInfoRow(
                              context,
                              label: "${item.quantity}x ${item.name}",
                              value:
                                  "\$${(item.price * item.quantity).toStringAsFixed(2)}")),
                        const Divider(height: 24),
                        _buildInfoRow(context,
                            label: "Special Instructions", value: "None"),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- Payment Summary Section ---
                    _buildSectionHeader(context,
                        icon: Icons.credit_card_outlined,
                        title: "Payment Summary"),
                    const SizedBox(height: 8),
                    _buildInfoCard(
                      children: [
                        _buildPriceRow(context, "Subtotal",
                            "\$${subtotal.toStringAsFixed(2)}"),
                        const SizedBox(height: 8),
                        _buildPriceRow(context, "Pickup & Delivery",
                            "\$${delivery.toStringAsFixed(2)}"),
                        const SizedBox(height: 8),
                        _buildPriceRow(
                            context, "Tax", "\$${tax.toStringAsFixed(2)}"),
                        const Divider(height: 24),
                        _buildPriceRow(
                            context, "Total", "\$${total.toStringAsFixed(2)}",
                            isTotal: true),
                      ],
                    ),
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

  // --- NEW HELPER WIDGETS ---

  Widget _buildSectionHeader(BuildContext context,
      {required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context,
      {required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context, String label, String price,
      {bool isTotal = false}) {
    final textTheme = Theme.of(context).textTheme;
    final style = isTotal
        ? textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
        : textTheme.bodyLarge;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(price, style: style),
      ],
    );
  }
}
