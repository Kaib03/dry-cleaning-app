// Purpose: Data model for a single dry cleaning service (e.g., Shirt, Suit).
class ServiceItem {
  final String id;
  final String name;
  final double price;
  int quantity;

  ServiceItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 0,
  });
} 