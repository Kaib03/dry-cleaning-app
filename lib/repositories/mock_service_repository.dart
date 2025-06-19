// Purpose: A fake implementation of the service repository.
import '../models/service_category.dart';
import 'abstract_service_repository.dart';
import '../models/specific_service_item.dart';
import '../models/service_extra.dart';

class MockServiceRepository implements AbstractServiceRepository {
  @override
  Future<List<ServiceCategory>> getAvailableServices() async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 400));

    // This data structure now reflects Categories containing specific Items.
    return [
      ServiceCategory(id: 'cat_shirts', name: 'Shirts', items: [
        SpecificServiceItem(
            id: 'item_shirt_standard',
            name: 'Standard Shirt',
            price: 6.90,
            availableExtras: [
              ServiceExtra(
                  id: 'extra_press_only',
                  name: 'Press Only',
                  priceAdjustment: -1.50),
              ServiceExtra(
                  id: 'extra_stain',
                  name: 'Stain Treatment',
                  priceAdjustment: 3.00),
            ]),
        SpecificServiceItem(
            id: 'item_shirt_tshirt', name: 'T-Shirt', price: 5.96),
        SpecificServiceItem(
            id: 'item_shirt_polo', name: 'Polo Shirt', price: 6.90),
        SpecificServiceItem(
            id: 'item_shirt_blouse',
            name: 'Blouse',
            price: 7.50,
            availableExtras: [
              ServiceExtra(
                  id: 'extra_stain',
                  name: 'Stain Treatment',
                  priceAdjustment: 3.00),
            ]),
      ]),
      ServiceCategory(id: 'cat_suits', name: 'Suits', items: [
        SpecificServiceItem(
            id: 'item_suit_two_piece', name: 'Two-Piece Suit', price: 12.00),
        SpecificServiceItem(
            id: 'item_suit_three_piece',
            name: 'Three-Piece Suit',
            price: 15.00),
        SpecificServiceItem(
            id: 'item_suit_blazer', name: 'Blazer/Jacket', price: 8.00),
      ]),
      ServiceCategory(id: 'cat_dresses', name: 'Dresses', items: [
        SpecificServiceItem(
            id: 'item_dress_standard', name: 'Standard Dress', price: 8.50),
        SpecificServiceItem(
            id: 'item_dress_silk', name: 'Silk Dress', price: 11.95),
        SpecificServiceItem(
            id: 'item_dress_evening', name: 'Evening Gown', price: 18.00),
      ]),
      ServiceCategory(id: 'cat_bedding', name: 'Bedding', items: [
        SpecificServiceItem(
            id: 'item_bedding_sheets', name: 'Sheet Set', price: 15.00),
        SpecificServiceItem(
            id: 'item_bedding_duvet', name: 'Duvet Cover', price: 18.00),
      ]),
      ServiceCategory(id: 'cat_coats', name: 'Coats & Jackets', items: [
        SpecificServiceItem(
            id: 'item_coats_winter', name: 'Winter Coat', price: 18.00),
        SpecificServiceItem(
            id: 'item_coats_trench', name: 'Trench Coat', price: 20.00),
      ]),
    ];
  }
}
