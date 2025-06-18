import 'service_extra.dart';

class SpecificServiceItem {
  final String id;
  final String name;
  final double price;
  final List<ServiceExtra> availableExtras;

  SpecificServiceItem({
    required this.id,
    required this.name,
    required this.price,
    this.availableExtras = const [],
  });
}
