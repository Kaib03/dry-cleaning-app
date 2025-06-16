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

  // Setters will be added here later
}
