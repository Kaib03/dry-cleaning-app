// Purpose: UI for Step 1: Pickup & Delivery Address Entry.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_localizations.dart';
import '../../models/user_address.dart';
import '../../repositories/mock_user_address_repository.dart';
import '../../widgets/common/primary_button.dart';
import '../../state/order_provider.dart';

class AddressEntryScreen extends StatefulWidget {
  final VoidCallback onNext; // Add this
  const AddressEntryScreen(
      {super.key, required this.onNext}); // Update constructor

  @override
  _AddressEntryScreenState createState() => _AddressEntryScreenState();
}

class _AddressEntryScreenState extends State<AddressEntryScreen> {
  late Future<List<UserAddress>> _recentAddressesFuture;
  final _repository = MockUserAddressRepository();

  // TextEditingControllers for form fields
  final _pickupStreetController = TextEditingController();
  final _pickupAptController = TextEditingController();
  final _pickupCityController = TextEditingController();
  final _pickupZipController = TextEditingController();
  final _deliveryAptController = TextEditingController(); // Add this

  // State for delivery address toggle
  bool _isSameAsPickup = true;

  @override
  void initState() {
    super.initState();
    _recentAddressesFuture = _repository.getRecentAddresses();
  }

  @override
  void dispose() {
    _pickupStreetController.dispose();
    _pickupAptController.dispose();
    _pickupCityController.dispose();
    _pickupZipController.dispose();
    _deliveryAptController.dispose(); // Add this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Scaffold(
          appBar: AppBar(
            title: Text(localizations.pickup_address_title),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Form Fields
                Text(localizations.street_address,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextField(
                  controller: _pickupStreetController, // Add this
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "123 Main Street"),
                ),
                const SizedBox(height: 16),
                Text(localizations.apt_unit,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextField(
                  controller: _pickupAptController, // Add this
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Apt 4B"),
                ),
                const SizedBox(height: 24),

                // Recent Addresses Section
                Text(localizations.recent_addresses,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                FutureBuilder<List<UserAddress>>(
                  future: _recentAddressesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text("Could not load addresses."));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No recent addresses."));
                    }
                    final addresses = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        return GestureDetector(
                          // Wrap the Card
                          onTap: () {
                            setState(() {
                              // A simplified split for this mock data
                              final parts = address.street.split(',');
                              _pickupStreetController.text =
                                  parts.isNotEmpty ? parts[0].trim() : '';
                              _pickupAptController.text =
                                  parts.length > 1 ? parts[1].trim() : '';
                              _pickupCityController.text = address.city;
                              _pickupZipController.text = address.zipCode;
                            });
                          },
                          child: Card(
                            // The existing Card
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              leading: const Icon(Icons.history),
                              title: Text(address.street),
                              subtitle:
                                  Text("${address.city}, ${address.zipCode}"),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                SwitchListTile(
                  title: Text(localizations.delivery_same_as_pickup,
                      style: Theme.of(context).textTheme.titleMedium),
                  value: _isSameAsPickup,
                  onChanged: (bool value) {
                    setState(() {
                      _isSameAsPickup = value;
                    });
                  },
                ),

                // Hidden delivery form
                if (!_isSameAsPickup)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(localizations.delivery_address,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16),
                      Text(localizations.street_address,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      const TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter delivery address")),
                      const SizedBox(height: 16),
                      Text(localizations.apt_unit,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _deliveryAptController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter Apt/Unit"),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: PrimaryButton(
              text: localizations.continue_button,
              onPressed: () {
                // Use the Provider to get the OrderProvider instance
                final orderProvider =
                    Provider.of<OrderProvider>(context, listen: false);

                // Create a UserAddress object from the controllers
                final pickupAddress = UserAddress(
                  street: _pickupStreetController.text,
                  apartment: _pickupAptController.text,
                  city: _pickupCityController.text.isEmpty
                      ? "Default City"
                      : _pickupCityController.text,
                  zipCode: _pickupZipController.text.isEmpty
                      ? "00000"
                      : _pickupZipController.text,
                );

                orderProvider.setPickupAddress(pickupAddress);

                // Also handle delivery address
                if (_isSameAsPickup) {
                  orderProvider.setDeliveryAddress(pickupAddress);
                } else {
                  // In a real app, you'd create a separate Delivery Address object
                  orderProvider.setDeliveryAddress(null);
                }

                // Navigate to the next page
                widget.onNext();
              },
            ),
          ),
        ),
      ),
    );
  }
}
