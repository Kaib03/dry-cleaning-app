// Purpose: Defines the contract (interface) for service-related data operations.
import '../models/service_category.dart';

abstract class AbstractServiceRepository {
  Future<List<ServiceCategory>> getAvailableServices();
}
