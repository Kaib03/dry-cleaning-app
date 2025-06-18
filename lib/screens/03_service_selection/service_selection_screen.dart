// Purpose: UI for Step 3: Selecting items and add-ons.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../models/service_category.dart';
import '../../models/service_item.dart';
import '../../models/specific_service_item.dart';
import '../../models/service_extra.dart';
import '../../repositories/mock_service_repository.dart';
import '../../widgets/common/step_progress_bar.dart';
import '../../state/order_provider.dart';

class ServiceSelectionScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;

  const ServiceSelectionScreen(
      {super.key,
      required this.currentStep,
      required this.onNext,
      required this.onBack});

  @override
  _ServiceSelectionScreenState createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  late Future<List<ServiceCategory>> _servicesFuture;
  final _repository = MockServiceRepository();
  final List<ServiceItem> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _servicesFuture = _repository.getAvailableServices();
  }

  double get _subtotal {
    return 0;
  }

  int get _totalItems =>
      _selectedItems.fold(0, (sum, item) => sum + item.quantity);

  Map<String, IconData> get _serviceIcons => {
        'shirts': Icons.checkroom,
        'suits': Icons.person,
        'dresses': Icons.woman,
        'bedding': Icons.bed,
        'coats': Icons.ac_unit,
      };

  Map<String, Color> get _serviceColors => {
        'shirts': const Color(0xFFE9E7FC), // Light Purple
        'suits': const Color(0xFFE9E7FC), // Light Purple
        'dresses': const Color(0xFFFCE7F3), // Light Pink
        'bedding': const Color(0xFFD1FAE5), // Light Green
        'coats': const Color(0xFFFFEED9), // Light Orange
      };

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBack,
            ),
            title: Text(localizations.select_services_title),
          ),
          body: Column(
            children: [
              StepProgressBar(currentStep: widget.currentStep, totalSteps: 4),
              Expanded(
                child: Stack(
                  children: [
                    FutureBuilder<List<ServiceCategory>>(
                      future: _servicesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text("No services available."));
                        }
                        final services = snapshot.data!;
                        return GridView.builder(
                          padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              top: 16.0,
                              bottom: 200.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1,
                          ),
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            final service = services[index];
                            final serviceKey =
                                service.name.toLowerCase().replaceAll(' ', '');
                            final icon =
                                _serviceIcons[serviceKey] ?? Icons.checkroom;

                            return GestureDetector(
                              onTap: () {
                                final category = services[index];
                                _showItemSelectionModal(context, category);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _serviceColors[serviceKey] ??
                                      Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      icon,
                                      size: 40,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(service.name),
                                  ],
                                ),
                              ),
                            );
                          },
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Subtotal',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
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
                                    onPressed: () {
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showItemSelectionModal(BuildContext context, ServiceCategory category) {
    // State for this modal instance
    final Map<String, int> modalQuantities = {};
    bool isShowingExtras = false;
    final Map<String, bool> selectedExtras = {};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Use a single StatefulBuilder for the whole dialog
        return StatefulBuilder(builder: (context, setDialogState) {
          Widget content;
          List<Widget> actions;
          String title = category.name;

          // Determine which view to show
          if (!isShowingExtras) {
            // VIEW 1: ITEM SELECTION
            content = ListView.builder(
              shrinkWrap: true,
              itemCount: category.items.length,
              itemBuilder: (context, index) {
                final specificItem = category.items[index];
                final quantity = modalQuantities[specificItem.id] ?? 0;
                return ListTile(
                  title: Text(specificItem.name),
                  subtitle: Text('\$${specificItem.price.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: quantity > 0
                            ? () {
                                setDialogState(() {
                                  modalQuantities[specificItem.id] =
                                      quantity - 1;
                                });
                              }
                            : null,
                      ),
                      Text('$quantity',
                          style: Theme.of(context).textTheme.titleMedium),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setDialogState(() {
                            modalQuantities[specificItem.id] = quantity + 1;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            );

            actions = [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Continue'),
                onPressed: () {
                  final hasSelection =
                      modalQuantities.values.any((qty) => qty > 0);
                  if (hasSelection) {
                    setDialogState(() {
                      isShowingExtras = true;
                    });
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ];
          } else {
            // VIEW 2: EXTRAS SELECTION
            title = 'Select Extras';
            final itemsWithQuantities = category.items
                .where((item) => (modalQuantities[item.id] ?? 0) > 0);
            final uniqueExtras = <String, ServiceExtra>{};
            for (var item in itemsWithQuantities) {
              for (var extra in item.availableExtras) {
                uniqueExtras[extra.id] = extra;
              }
            }

            if (uniqueExtras.isEmpty) {
              content = const Center(
                child: Text('No extras available for selected items.'),
              );
            } else {
              content = ListView(
                shrinkWrap: true,
                children: uniqueExtras.values.map((extra) {
                  return SwitchListTile(
                    title: Text(extra.name),
                    subtitle: Text(
                        '${extra.priceAdjustment >= 0 ? '+' : ''}\$${extra.priceAdjustment.toStringAsFixed(2)}'),
                    value: selectedExtras[extra.id] ?? false,
                    onChanged: (bool value) {
                      setDialogState(() {
                        selectedExtras[extra.id] = value;
                      });
                    },
                  );
                }).toList(),
              );
            }

            actions = [
              TextButton(
                  child: const Text('Back'),
                  onPressed: () {
                    setDialogState(() {
                      isShowingExtras = false;
                    });
                  }),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Add to Order'),
                onPressed: () {
                  // Final "Add to order" logic will go here
                  Navigator.of(context).pop();
                },
              )
            ];
          }

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Text(title, textAlign: TextAlign.center),
            content: SizedBox(
              width: 300, // Constrain the width for a phone-like dialog
              height: 400, // Constrain the height of the dialog
              child: content,
            ),
            actions: actions,
          );
        });
      },
    );
  }
}
