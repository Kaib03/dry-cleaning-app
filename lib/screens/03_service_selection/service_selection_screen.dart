// Purpose: UI for Step 3: Selecting items and add-ons.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../models/service_category.dart';
import '../../models/service_item.dart';
import '../../models/service_extra.dart';
import '../../repositories/mock_service_repository.dart';
import '../../state/order_provider.dart';
import '../../widgets/common/step_progress_bar.dart';

class ServiceSelectionScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback? onValidationChanged;

  const ServiceSelectionScreen(
      {super.key,
      required this.onNext,
      required this.onBack,
      this.onValidationChanged});

  @override
  State<ServiceSelectionScreen> createState() => ServiceSelectionScreenState();
}

class ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  late Future<List<ServiceCategory>> _servicesFuture;
  final _repository = MockServiceRepository();
  final List<ServiceItem> _selectedItems = [];
  bool _isCartExpanded = true;

  @override
  void initState() {
    super.initState();
    _servicesFuture = _repository.getAvailableServices();

    // Initialize with existing selected items from OrderProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      if (orderProvider.selectedItems.isNotEmpty) {
        setState(() {
          _selectedItems.clear();
          _selectedItems.addAll(orderProvider.selectedItems);
        });
      }
      // Notify parent about validation state
      widget.onValidationChanged?.call();
    });
  }

  double get _subtotal {
    return _selectedItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get _totalItems =>
      _selectedItems.fold(0, (sum, item) => sum + item.quantity);

  bool canContinue() => _totalItems > 0;

  void submit() {
    if (!canContinue()) return;
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.setSelectedServices(
        _selectedItems.where((item) => item.quantity > 0).toList());
    widget.onNext();
  }

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
    return FutureBuilder<List<ServiceCategory>>(
      future: _servicesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No services available."));
        }
        final services = snapshot.data!;
        return Stack(
          children: [
            GridView.builder(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 16.0, bottom: 200.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                final icon = _serviceIcons[serviceKey] ?? Icons.checkroom;

                return GestureDetector(
                  onTap: () {
                    final category = services[index];
                    _showItemSelectionModal(context, category);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _serviceColors[serviceKey] ?? Colors.grey.shade100,
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
                    // Tappable header to toggle expansion
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isCartExpanded = !_isCartExpanded;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.order_summary,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              if (_totalItems > 0) ...[
                                Text(
                                  '€${_subtotal.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                '$_totalItems ${_totalItems == 1 ? AppLocalizations.of(context)!.item : AppLocalizations.of(context)!.items}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _isCartExpanded
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up,
                                color: Colors.grey.shade600,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Expandable content
                    if (_isCartExpanded) ...[
                      if (_totalItems > 0) ...[
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 8),

                        // Scrollable item list (max height to prevent taking up too much space)
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: SingleChildScrollView(
                            child: Column(
                              children: _selectedItems
                                  .where((item) => item.quantity > 0)
                                  .map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${item.quantity}x ${item.name}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                                // Show add-ons in brackets if any exist
                                                if (item
                                                    .selectedExtras.isNotEmpty)
                                                  Text(
                                                    '(${item.selectedExtras.map((e) => e.name).join(', ')})',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color: Colors
                                                              .grey.shade600,
                                                        ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '€${item.totalPrice.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (item.quantity > 1) {
                                                  // If more than 1, just decrease quantity
                                                  item.quantity -= 1;
                                                } else {
                                                  // If quantity is 1, remove the item completely
                                                  _selectedItems.removeWhere(
                                                      (selectedItem) =>
                                                          selectedItem.id ==
                                                          item.id);
                                                }
                                              });
                                              widget.onValidationChanged
                                                  ?.call();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                size: 16,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                        const Divider(height: 1),
                        const SizedBox(height: 8),

                        // Clear cart button
                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _selectedItems.clear();
                              });
                              widget.onValidationChanged?.call();
                            },
                            icon: Icon(Icons.delete_outline, size: 16),
                            label:
                                Text(AppLocalizations.of(context)!.clear_cart),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red.shade600,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(height: 1),
                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.subtotal,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              '€${_subtotal.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ] else ...[
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context)!.no_items_selected,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showItemSelectionModal(BuildContext context, ServiceCategory category) {
    final localizations = AppLocalizations.of(context)!;
    Map<String, int> modalQuantities = {};
    Map<String, bool> selectedExtras = {};
    bool isShowingExtras = false;

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
                  subtitle: Text('€${specificItem.price.toStringAsFixed(2)}'),
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
                child: Text(localizations.cancel),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(localizations.continue_button),
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
            title = localizations.select_extras;
            final itemsWithQuantities = category.items
                .where((item) => (modalQuantities[item.id] ?? 0) > 0);
            final uniqueExtras = <String, ServiceExtra>{};
            for (var item in itemsWithQuantities) {
              for (var extra in item.availableExtras) {
                uniqueExtras[extra.id] = extra;
              }
            }

            if (uniqueExtras.isEmpty) {
              content = Center(
                child: Text(localizations.no_extras_available),
              );
            } else {
              content = ListView(
                shrinkWrap: true,
                children: uniqueExtras.values.map((extra) {
                  return SwitchListTile(
                    title: Text(extra.name),
                    subtitle: Text(
                        '${extra.priceAdjustment >= 0 ? '+' : ''}€${extra.priceAdjustment.toStringAsFixed(2)}'),
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
                  child: Text(localizations.back),
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
                child: Text(localizations.add_to_order),
                onPressed: () {
                  // Update the main state with selected items
                  modalQuantities.forEach((itemId, quantity) {
                    if (quantity > 0) {
                      final specificItem = category.items
                          .firstWhere((item) => item.id == itemId);

                      // Get selected add-ons for this item
                      final selectedAddOns = <ServiceExtra>[];
                      for (var extra in specificItem.availableExtras) {
                        if (selectedExtras[extra.id] == true) {
                          selectedAddOns.add(extra);
                        }
                      }

                      // Create a unique key based on item ID + sorted add-on IDs
                      final addOnIds = selectedAddOns.map((e) => e.id).toList()
                        ..sort();
                      final uniqueKey = '${itemId}_${addOnIds.join('_')}';

                      // Find existing item with same item ID and same add-ons
                      final existingIndex = _selectedItems.indexWhere((item) {
                        final existingAddOnIds = item.selectedExtras
                            .map((e) => e.id)
                            .toList()
                          ..sort();
                        final existingKey =
                            '${item.id}_${existingAddOnIds.join('_')}';
                        return existingKey == uniqueKey;
                      });

                      if (existingIndex >= 0) {
                        // Item with same add-ons already exists, combine quantities
                        final existingItem = _selectedItems[existingIndex];
                        _selectedItems[existingIndex] = existingItem.copyWith(
                          quantity: existingItem.quantity + quantity,
                        );
                      } else {
                        // New item or item with different add-ons, add as new entry
                        final serviceItem = ServiceItem(
                          id: specificItem.id,
                          name: specificItem.name,
                          price: specificItem.price,
                          quantity: quantity,
                          selectedExtras: selectedAddOns,
                        );
                        _selectedItems.add(serviceItem);
                      }
                    }
                  });

                  setState(() {});
                  widget.onValidationChanged?.call();
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
