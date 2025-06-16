// Purpose: State management provider (e.g., using Riverpod/Provider) to hold and manage the order details across all steps.
import 'package:flutter/foundation.dart';
import '../models/user_address.dart';
import '../models/schedule_slot.dart';
import '../models/service_item.dart';

class OrderProvider with ChangeNotifier {
  UserAddress? _pickupAddress;
  UserAddress? _deliveryAddress;
  ScheduleSlot? _scheduleSlot;
  final List<ServiceItem> _selectedItems = [];

  // Getters
  UserAddress? get pickupAddress => _pickupAddress;
  UserAddress? get deliveryAddress => _deliveryAddress;
  ScheduleSlot? get scheduleSlot => _scheduleSlot;
  List<ServiceItem> get selectedItems => _selectedItems;

  // Setters
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
}
