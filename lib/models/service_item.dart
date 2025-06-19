// Purpose: Data model for a single dry cleaning service (e.g., Shirt, Suit).
import 'service_extra.dart';

class ServiceItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final List<ServiceExtra> selectedExtras;

  ServiceItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 0,
    this.selectedExtras = const [],
  });

  ServiceItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    List<ServiceExtra>? selectedExtras,
  }) {
    return ServiceItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      selectedExtras: selectedExtras ?? this.selectedExtras,
    );
  }

  // Calculate total price including add-ons
  double get totalPrice {
    double basePrice = price * quantity;
    double extrasPrice =
        selectedExtras.fold(0.0, (sum, extra) => sum + extra.priceAdjustment) *
            quantity;
    return basePrice + extrasPrice;
  }
}
