// Purpose: Defines the contract (interface) for service-related data operations.
import '../models/service_item.dart';

abstract class AbstractServiceRepository {
  Future<List<ServiceItem>> getAvailableServices();
}
