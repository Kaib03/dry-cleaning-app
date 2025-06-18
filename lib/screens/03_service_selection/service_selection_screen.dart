// Purpose: UI for Step 3: Selecting items and add-ons.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../models/service_item.dart';
import '../../repositories/mock_service_repository.dart';

import '../../state/order_provider.dart';

class ServiceSelectionScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ServiceSelectionScreen(
      {Key? key, required this.onNext, required this.onBack})
      : super(key: key);

  @override
  _ServiceSelectionScreenState createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  late Future<List<ServiceItem>> _servicesFuture;
  final _repository = MockServiceRepository();
  final Map<String, int> _itemQuantities = {};
  bool _pressOnly = false;
  bool _stainRemoval = false;

  @override
  void initState() {
    super.initState();
    _servicesFuture = _repository.getAvailableServices();
  }

  double get _subtotal {
    double total = 0;
    for (var entry in _itemQuantities.entries) {
      // This is a simplified calculation - in real app would use proper service lookup
      total += entry.value * 12.0; // Approximate price
    }
    if (_pressOnly) total += 2.0;
    if (_stainRemoval) total += 3.0;
    return total;
  }

  int get _totalItems {
    int total =
        _itemQuantities.values.fold(0, (sum, quantity) => sum + quantity);
    if (_pressOnly) total++;
    if (_stainRemoval) total++;
    return total;
  }

  Map<String, IconData> get _serviceIcons => {
        'shirts': Icons.checkroom,
        'suits': Icons.person,
        'dresses': Icons.woman,
        'bedding': Icons.bed,
        'coats': Icons.ac_unit,
      };

  Map<String, Color> get _serviceColors => {
        'shirts': Colors.blue.shade100,
        'suits': Colors.purple.shade100,
        'dresses': Colors.pink.shade100,
        'bedding': Colors.green.shade100,
        'coats': Colors.orange.shade100,
      };

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: Text(localizations.select_services_title),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<ServiceItem>>(
            future: _servicesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No services available."));
              }
              final services = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 16.0, bottom: 200.0),
                children: [
                  // Service items
                  ...services.map((service) {
                    final quantity = _itemQuantities[service.id] ?? 0;
                    final serviceKey =
                        service.name.toLowerCase().replaceAll(' ', '');
                    final icon = _serviceIcons[serviceKey] ?? Icons.checkroom;
                    final color =
                        _serviceColors[serviceKey] ?? Colors.blue.shade100;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Icon(icon,
                                color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  '\$${service.price.toStringAsFixed(2)} each',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.remove, size: 20),
                                  onPressed: quantity > 0
                                      ? () => setState(() =>
                                          _itemQuantities[service.id] =
                                              quantity - 1)
                                      : null,
                                  color: quantity > 0
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  '$quantity',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.add, size: 20),
                                  onPressed: () => setState(() =>
                                      _itemQuantities[service.id] =
                                          quantity + 1),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  // Add-ons section
                  CheckboxListTile(
                    title: Text('Press only (+\$2.00)'),
                    value: _pressOnly,
                    onChanged: (value) =>
                        setState(() => _pressOnly = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: Text('Stain removal (+\$3.00)'),
                    value: _stainRemoval,
                    onChanged: (value) =>
                        setState(() => _stainRemoval = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              );
            },
          ),

          // Floating summary card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order Summary',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$_totalItems item${_totalItems == 1 ? '' : 's'}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  if (_totalItems > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '\$${_subtotal.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: widget.onBack,
                          child: Text('Back'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            final orderProvider = Provider.of<OrderProvider>(
                                context,
                                listen: false);
                            final services = await _servicesFuture;
                            final selectedServices = services.where((service) {
                              final quantity = _itemQuantities[service.id] ?? 0;
                              return quantity > 0;
                            }).map((service) {
                              return ServiceItem(
                                id: service.id,
                                name: service.name,
                                price: service.price,
                                quantity: _itemQuantities[service.id] ?? 0,
                              );
                            }).toList();

                            orderProvider.setSelectedServices(selectedServices);
                            widget.onNext();
                          },
                          child: Text('Continue'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
