// Purpose: UI for Step 1: Pickup & Delivery Address Entry.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_localizations.dart';
import '../../state/order_provider.dart';
import '../../models/user_address.dart';

class AddressEntryScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onValidationChanged;

  const AddressEntryScreen({
    super.key,
    required this.onNext,
    this.onValidationChanged,
  });

  @override
  State<AddressEntryScreen> createState() => AddressEntryScreenState();
}

class AddressEntryScreenState extends State<AddressEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Personal information controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // Pickup address controllers
  final _pickupStreetController = TextEditingController();
  final _pickupAptController = TextEditingController();
  final _pickupCityController = TextEditingController();
  final _pickupZipController = TextEditingController();

  // Delivery address controllers
  final _deliveryStreetController = TextEditingController();
  final _deliveryAptController = TextEditingController();
  final _deliveryCityController = TextEditingController();
  final _deliveryZipController = TextEditingController();

  bool _isSameAsPickup = true;
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();

    // Populate controllers with existing data from OrderProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      // Populate personal information if it exists
      if (orderProvider.firstName != null) {
        _firstNameController.text = orderProvider.firstName!;
      }
      if (orderProvider.lastName != null) {
        _lastNameController.text = orderProvider.lastName!;
      }
      if (orderProvider.phone != null) {
        _phoneController.text = orderProvider.phone!;
      }
      if (orderProvider.email != null) {
        _emailController.text = orderProvider.email!;
      }

      // Populate pickup address if it exists
      if (orderProvider.pickupAddress != null) {
        final pickup = orderProvider.pickupAddress!;
        _pickupStreetController.text = pickup.street;
        _pickupCityController.text = pickup.city;
        _pickupZipController.text = pickup.zipCode;
        if (pickup.apartment != null) {
          _pickupAptController.text = pickup.apartment!;
        }
      }

      // Populate delivery address if it exists and is different from pickup
      if (orderProvider.deliveryAddress != null) {
        final delivery = orderProvider.deliveryAddress!;
        if (delivery != orderProvider.pickupAddress) {
          setState(() {
            _isSameAsPickup = false;
          });
          _deliveryStreetController.text = delivery.street;
          _deliveryCityController.text = delivery.city;
          _deliveryZipController.text = delivery.zipCode;
          if (delivery.apartment != null) {
            _deliveryAptController.text = delivery.apartment!;
          }
        }
      }

      // Trigger validation after populating
      _validateForm();
    });

    // Add listeners for all form fields
    _firstNameController.addListener(_validateForm);
    _lastNameController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _pickupStreetController.addListener(_validateForm);
    _pickupCityController.addListener(_validateForm);
    _pickupZipController.addListener(_validateForm);
    _deliveryStreetController.addListener(_validateForm);
    _deliveryCityController.addListener(_validateForm);
    _deliveryZipController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _pickupStreetController.dispose();
    _pickupAptController.dispose();
    _pickupCityController.dispose();
    _pickupZipController.dispose();
    _deliveryStreetController.dispose();
    _deliveryAptController.dispose();
    _deliveryCityController.dispose();
    _deliveryZipController.dispose();
    super.dispose();
  }

  void _validateForm() {
    // Manual validation check - include personal info and address fields
    bool isValid = _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _pickupStreetController.text.isNotEmpty &&
        _pickupCityController.text.isNotEmpty &&
        _pickupZipController.text.isNotEmpty;

    // If delivery address is different, also validate those fields
    if (!_isSameAsPickup) {
      isValid = isValid &&
          _deliveryStreetController.text.isNotEmpty &&
          _deliveryCityController.text.isNotEmpty &&
          _deliveryZipController.text.isNotEmpty;
    }

    if (isValid != _canContinue) {
      setState(() {
        _canContinue = isValid;
      });
      // Notify parent that validation state changed
      widget.onValidationChanged?.call();
    }
  }

  bool canContinue() {
    // Check if personal info and pickup address fields are filled
    bool isValid = _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _pickupStreetController.text.isNotEmpty &&
        _pickupCityController.text.isNotEmpty &&
        _pickupZipController.text.isNotEmpty;

    // If delivery address is different, also check those fields
    if (!_isSameAsPickup) {
      isValid = isValid &&
          _deliveryStreetController.text.isNotEmpty &&
          _deliveryCityController.text.isNotEmpty &&
          _deliveryZipController.text.isNotEmpty;
    }

    return isValid;
  }

  void submitAddress() {
    if (_formKey.currentState!.validate()) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      // Save personal information
      orderProvider.setPersonalInfo(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
      );

      // Save pickup address
      final pickupAddress = UserAddress(
        street: _pickupStreetController.text,
        apartment: _pickupAptController.text,
        city: _pickupCityController.text,
        zipCode: _pickupZipController.text,
      );
      orderProvider.setPickupAddress(pickupAddress);

      // Save delivery address
      if (_isSameAsPickup) {
        orderProvider.setDeliveryAddress(pickupAddress);
      } else {
        final deliveryAddress = UserAddress(
          street: _deliveryStreetController.text,
          apartment: _deliveryAptController.text,
          city: _deliveryCityController.text,
          zipCode: _deliveryZipController.text,
        );
        orderProvider.setDeliveryAddress(deliveryAddress);
      }

      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: _validateForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Information Section
            Text(localizations.personal_information_title,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: localizations.first_name,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty
                        ? localizations.please_enter_first_name
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: localizations.last_name,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty
                        ? localizations.please_enter_last_name
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: localizations.phone_number,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  value!.isEmpty ? localizations.please_enter_phone : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: localizations.email,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) return localizations.please_enter_email;
                if (!value.contains('@'))
                  return localizations.please_enter_valid_email;
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Pickup Address Section
            Text(localizations.pickup_address_title,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildAddressFields(
              localizations: localizations,
              streetController: _pickupStreetController,
              aptController: _pickupAptController,
              cityController: _pickupCityController,
              zipController: _pickupZipController,
            ),
            const SizedBox(height: 24),

            // Delivery Address Toggle
            SwitchListTile(
              title: Text(localizations.delivery_same_as_pickup,
                  style: Theme.of(context).textTheme.titleMedium),
              value: _isSameAsPickup,
              onChanged: (bool value) {
                setState(() {
                  _isSameAsPickup = value;
                });
                // Re-validate when the switch is toggled
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _validateForm());
              },
              secondary: const Icon(Icons.local_shipping_outlined),
              contentPadding: EdgeInsets.zero,
            ),

            // Delivery Address Section (conditional)
            if (!_isSameAsPickup) ...[
              const SizedBox(height: 24),
              Text(localizations.delivery_address,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _buildAddressFields(
                localizations: localizations,
                streetController: _deliveryStreetController,
                aptController: _deliveryAptController,
                cityController: _deliveryCityController,
                zipController: _deliveryZipController,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddressFields({
    required AppLocalizations localizations,
    required TextEditingController streetController,
    required TextEditingController aptController,
    required TextEditingController cityController,
    required TextEditingController zipController,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: streetController,
          decoration: InputDecoration(
            labelText: localizations.street_address,
            border: const OutlineInputBorder(),
          ),
          validator: (value) =>
              value!.isEmpty ? localizations.please_enter_street_address : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: aptController,
          decoration: InputDecoration(
            labelText: '${localizations.apt_unit} (${localizations.optional})',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: localizations.city,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? localizations.please_enter_city : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: zipController,
                decoration: InputDecoration(
                  labelText: localizations.zip_code,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? localizations.please_enter_zip_code : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
