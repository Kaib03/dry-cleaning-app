// Purpose: UI for Step 1: Pickup & Delivery Address Entry.
import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../models/user_address.dart';
import '../../repositories/mock_user_address_repository.dart';
import '../../widgets/common/primary_button.dart';

class AddressEntryScreen extends StatefulWidget {
  const AddressEntryScreen({super.key});

  @override
  _AddressEntryScreenState createState() => _AddressEntryScreenState();
}

class _AddressEntryScreenState extends State<AddressEntryScreen> {
  late Future<List<UserAddress>> _recentAddressesFuture;
  final _repository = MockUserAddressRepository();

  @override
  void initState() {
    super.initState();
    _recentAddressesFuture = _repository.getRecentAddresses();
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
            const TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "123 Main Street")),
            const SizedBox(height: 16),
            Text("Apt/Unit", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Apt 4B")),
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
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(address.street),
                        subtitle: Text("${address.city}, ${address.zipCode}"),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          text: localizations.continue_button,
          onPressed: () {},
        ),
      ),
    );
  }
}
