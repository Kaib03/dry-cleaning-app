// Purpose: State management provider (e.g., using Riverpod/Provider) to hold and manage the order details across all steps.
import 'package:flutter/foundation.dart';
import '../models/user_address.dart';
import '../models/schedule_slot.dart';
import '../models/service_item.dart';

class OrderProvider with ChangeNotifier {
  // Personal information
  String? _firstName;
  String? _lastName;
  String? _phone;
  String? _email;

  UserAddress? _pickupAddress;
  UserAddress? _deliveryAddress;
  ScheduleSlot? _scheduleSlot;
  String? _specialInstructions;
  final List<ServiceItem> _selectedItems = [];

  // Getters
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get phone => _phone;
  String? get email => _email;
  UserAddress? get pickupAddress => _pickupAddress;
  UserAddress? get deliveryAddress => _deliveryAddress;
  ScheduleSlot? get scheduleSlot => _scheduleSlot;
  String? get specialInstructions => _specialInstructions;
  List<ServiceItem> get selectedItems => _selectedItems;

  // Setters
  void setPersonalInfo({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _phone = phone;
    _email = email;
    notifyListeners();
  }

  void setPickupAddress(UserAddress address) {
    _pickupAddress = address;
    notifyListeners();
  }

  void setDeliveryAddress(UserAddress? address) {
    _deliveryAddress = address;
    notifyListeners();
  }

  void setSchedule(ScheduleSlot slot) {
    _scheduleSlot = slot;
    notifyListeners();
  }

  void setSelectedServices(List<ServiceItem> items) {
    _selectedItems.clear();
    _selectedItems.addAll(items);
    notifyListeners();
  }

  void setSpecialInstructions(String? instructions) {
    _specialInstructions = instructions;
    notifyListeners();
  }
}
