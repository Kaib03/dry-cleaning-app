// Purpose: UI for Step 3: Selecting items and add-ons.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../models/service_item.dart';
import '../../repositories/mock_service_repository.dart';
import '../../widgets/common/primary_button.dart';
import '../../state/order_provider.dart';

class ServiceSelectionScreen extends StatefulWidget {
  final VoidCallback onNext;

  const ServiceSelectionScreen({Key? key, required this.onNext})
      : super(key: key);

  @override
  _ServiceSelectionScreenState createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  late Future<List<ServiceItem>> _servicesFuture;
  final _repository = MockServiceRepository();
  final Map<String, int> _itemQuantities = {};

  @override
  void initState() {
    super.initState();
    _servicesFuture = _repository.getAvailableServices();
  }

  double get _subtotal {
    double total = 0;
    // This is a simplified calculation. A real app would get this from the state/provider.
    _servicesFuture.then((services) {
      for (var service in services) {
        total += (_itemQuantities[service.id] ?? 0) * service.price;
      }
    });
    // In a real app, you would manage this more robustly. For now, this is a placeholder.
    // For the UI to update, we'd need to calculate this from a list held in state.
    // This calculation logic will be improved when we wire up state management.
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Scaffold(
          appBar: AppBar(title: Text(localizations.select_services_title)),
          body: FutureBuilder<List<ServiceItem>>(
            future: _servicesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No services available."));
              }
              final services = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  final quantity = _itemQuantities[service.id] ?? 0;
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(service.name,
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 4),
                              Text(
                                  "\$${service.price.toStringAsFixed(2)} each"),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: quantity > 0
                                    ? () => setState(() =>
                                        _itemQuantities[service.id] =
                                            quantity - 1)
                                    : null,
                              ),
                              Text('$quantity',
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                onPressed: () => setState(() =>
                                    _itemQuantities[service.id] = quantity + 1),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: PrimaryButton(
              text: localizations.continue_button,
              onPressed: () async {
                final orderProvider =
                    Provider.of<OrderProvider>(context, listen: false);

                // Get the services and create the selected list
                final services = await _servicesFuture;
                final selectedServices = services.where((service) {
                  final quantity = _itemQuantities[service.id] ?? 0;
                  return quantity > 0;
                }).map((service) {
                  // Important: Create a new instance with the correct quantity
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
            ),
          ),
        ),
      ),
    );
  }
}
