// Purpose: UI for Step 1: Pickup & Delivery Address Entry.
import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../models/user_address.dart';
import '../../repositories/mock_user_address_repository.dart';
import '../../widgets/common/primary_button.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.pickup_address_title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Form Fields
            Text("Street Address",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _pickupStreetController, // Add this
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "123 Main Street"),
            ),
            const SizedBox(height: 16),
            Text("Apt/Unit", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _pickupAptController, // Add this
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Apt 4B"),
            ),
            const SizedBox(height: 24),

            // Recent Addresses Section
            Text("Recent Addresses",
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            FutureBuilder<List<UserAddress>>(
              future: _recentAddressesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Could not load addresses."));
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
                          subtitle: Text("${address.city}, ${address.zipCode}"),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: Text("Delivery address is the same as pickup",
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
                  Text("Delivery Address",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Text("Street Address",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter delivery address")),
                  // We can add more delivery fields here later
                ],
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          text: localizations.continue_button,
          onPressed: widget.onNext, // Use the callback here
        ),
      ),
    );
  }
}
