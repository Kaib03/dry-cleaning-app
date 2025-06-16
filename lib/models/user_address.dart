// Purpose: Data model for a user's address.
class UserAddress {
  final String street;
  final String city;
  final String zipCode;
  final String? apartment; // Optional
  final String? floor; // Optional
  final String? instructions; // Optional

  UserAddress({
    required this.street,
    required this.city,
    required this.zipCode,
    this.apartment,
    this.floor,
    this.instructions,
  });
} 