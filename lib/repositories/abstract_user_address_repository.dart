// Purpose: Defines the contract (interface) for user address data operations.
import '../models/user_address.dart';

abstract class AbstractUserAddressRepository {
  Future<List<UserAddress>> getRecentAddresses();
} 