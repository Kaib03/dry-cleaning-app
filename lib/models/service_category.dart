import 'specific_service_item.dart';

class ServiceCategory {
  final String id;
  final String name;
  final List<SpecificServiceItem>
      items; // A category contains a list of specific items

  ServiceCategory({
    required this.id,
    required this.name,
    required this.items,
  });
}
