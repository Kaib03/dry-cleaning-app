// Purpose: A fake implementation of the service repository.
import '../models/service_item.dart';
import 'abstract_service_repository.dart';

class MockServiceRepository implements AbstractServiceRepository {
  @override
  Future<List<ServiceItem>> getAvailableServices() async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      ServiceItem(id: '1', name: 'Shirts', price: 3.50),
      ServiceItem(id: '2', name: 'Suits', price: 12.00),
      ServiceItem(id: '3', name: 'Dresses', price: 8.50),
      ServiceItem(id: '4', name: 'Bedding', price: 15.00),
      ServiceItem(id: '5', name: 'Coats & Jackets', price: 18.00),
    ];
  }
}
