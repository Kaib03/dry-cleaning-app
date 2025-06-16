// Purpose: A fake implementation of the user address repository.
import '../models/user_address.dart';
import 'abstract_user_address_repository.dart';

class MockUserAddressRepository implements AbstractUserAddressRepository {
  @override
  Future<List<UserAddress>> getRecentAddresses() async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      UserAddress(street: "456 Oak Avenue, Apt 3A", city: "Brooklyn", zipCode: "11201"),
      UserAddress(street: "789 Business Blvd, Suite 500", city: "Manhattan", zipCode: "10004"),
    ];
  }
} 