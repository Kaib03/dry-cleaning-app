// Purpose: UI for the final step: Reviewing and confirming the order.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../state/order_provider.dart';
import '../../state/locale_provider.dart';
import '../../models/service_item.dart';
import 'package:intl/intl.dart';

class OrderSummaryScreen extends StatelessWidget {
  final VoidCallback onBack;
  final Function(int)? onEditStep; // Add callback to navigate to specific step

  const OrderSummaryScreen({super.key, required this.onBack, this.onEditStep});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        final localizations = AppLocalizations.of(context)!;
        final localeProvider = Provider.of<LocaleProvider>(context);
        // Format the data from the provider
        final pickupAddress = order.pickupAddress != null
            ? '${order.pickupAddress!.street}${(order.pickupAddress!.apartment?.isNotEmpty ?? false) ? ', ${order.pickupAddress!.apartment}' : ''}\n${order.pickupAddress!.city}, ${order.pickupAddress!.zipCode}'
            : localizations.not_selected;

        final deliveryAddress = order.deliveryAddress != null
            ? (order.deliveryAddress == order.pickupAddress
                ? localizations.same_as_pickup_address
                : '${order.deliveryAddress!.street}${(order.deliveryAddress!.apartment?.isNotEmpty ?? false) ? ', ${order.deliveryAddress!.apartment}' : ''}\n${order.deliveryAddress!.city}, ${order.deliveryAddress!.zipCode}')
            : localizations.not_selected;

        final pickupDate = order.scheduleSlot != null
            ? DateFormat('EEEE, MMMM d', localeProvider.locale.languageCode)
                .format(order.scheduleSlot!.date)
            : localizations.not_selected;

        final pickupTime = order.scheduleSlot != null
            ? '${order.scheduleSlot!.startTime.format(context)} - ${order.scheduleSlot!.endTime.format(context)}'
            : localizations.not_selected;

        // Calculate total from selected services
        double subtotal = 0;
        for (var item in order.selectedItems) {
          subtotal += item.totalPrice;
        }
        final delivery = 3.99;
        // No separate tax in Europe - prices include tax
        final total = subtotal + delivery;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Personal Information Section ---
              _buildSectionHeader(context,
                  icon: Icons.person_outline,
                  title: localizations.personal_information_title,
                  editStep: 0),
              const SizedBox(height: 8),
              _buildInfoCard(
                children: [
                  _buildInfoRow(context,
                      label: localizations.name,
                      value:
                          "${order.firstName ?? localizations.not_provided} ${order.lastName ?? localizations.not_provided}"),
                  const Divider(height: 24),
                  _buildInfoRow(context,
                      label: localizations.phone,
                      value: order.phone ?? localizations.not_provided),
                  const Divider(height: 24),
                  _buildInfoRow(context,
                      label: localizations.email,
                      value: order.email ?? localizations.not_provided),
                ],
              ),
              const SizedBox(height: 24),

              // --- Pickup & Delivery Section ---
              _buildSectionHeader(context,
                  icon: Icons.local_shipping_outlined,
                  title: localizations.pickup_and_delivery,
                  editStep: 1),
              const SizedBox(height: 8),
              _buildInfoCard(
                children: [
                  _buildInfoRow(context,
                      label: localizations.pickup_address_summary,
                      value: pickupAddress),
                  const Divider(height: 24),
                  _buildInfoRow(context,
                      label: localizations.delivery_address_label,
                      value: deliveryAddress),
                  const Divider(height: 24),
                  _buildInfoRow(context,
                      label: localizations.pickup_date, value: pickupDate),
                  const Divider(height: 24),
                  _buildInfoRow(context,
                      label: localizations.pickup_time, value: pickupTime),
                ],
              ),
              const SizedBox(height: 24),

              // --- Order Details Section ---
              _buildSectionHeader(context,
                  icon: Icons.list_alt_outlined,
                  title: localizations.order_details,
                  editStep: 2),
              const SizedBox(height: 8),
              _buildInfoCard(
                children: [
                  if (order.selectedItems.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(localizations.no_items_selected),
                    )
                  else
                    ...order.selectedItems
                        .map((item) => _buildItemRow(context, item)),
                  const Divider(height: 24),
                  _buildInfoRow(context,
                      label: localizations.special_instructions,
                      value: order.specialInstructions ?? localizations.none),
                ],
              ),
              const SizedBox(height: 24),

              // --- Payment Summary Section ---
              _buildSectionHeader(context,
                  icon: Icons.credit_card_outlined,
                  title: localizations.payment_summary),
              const SizedBox(height: 8),
              _buildInfoCard(
                children: [
                  _buildPriceRow(context, localizations.subtotal,
                      "€${subtotal.toStringAsFixed(2)}"),
                  const SizedBox(height: 8),
                  _buildPriceRow(context, localizations.pickup_delivery_fee,
                      "€${delivery.toStringAsFixed(2)}"),
                  const SizedBox(height: 8),
                  _buildPriceRow(context, localizations.total,
                      "€${total.toStringAsFixed(2)}",
                      isTotal: true),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // --- NEW HELPER WIDGETS ---

  Widget _buildSectionHeader(BuildContext context,
      {required IconData icon, required String title, int? editStep}) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        if (editStep != null && onEditStep != null)
          TextButton.icon(
            onPressed: () => onEditStep!(editStep),
            icon: Icon(Icons.edit,
                size: 16, color: Theme.of(context).primaryColor),
            label: Text(
              AppLocalizations.of(context)!.edit,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
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

  Widget _buildItemRow(BuildContext context, ServiceItem item) {
    // Build item name with add-ons in brackets (like service selection page)
    String itemLabel = "${item.quantity}x ${item.name}";
    if (item.selectedExtras.isNotEmpty) {
      final addOnsText = item.selectedExtras.map((e) => e.name).join(', ');
      itemLabel += "\n($addOnsText)";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item.quantity}x ${item.name}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (item.selectedExtras.isNotEmpty)
                  Text(
                    "(${item.selectedExtras.map((e) => e.name).join(', ')})",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            "€${item.totalPrice.toStringAsFixed(2)}",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
