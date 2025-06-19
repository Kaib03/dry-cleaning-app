import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String get continue_button {
    switch (locale.languageCode) {
      case 'es':
        return 'Continuar';
      case 'en':
      default:
        return 'Continue';
    }
  }

  String get pickup_address_title {
    switch (locale.languageCode) {
      case 'es':
        return 'Dirección de Recogida';
      case 'en':
      default:
        return 'Pickup Address';
    }
  }

  String get street_address {
    switch (locale.languageCode) {
      case 'es':
        return 'Dirección';
      case 'en':
      default:
        return 'Street Address';
    }
  }

  String get apt_unit {
    switch (locale.languageCode) {
      case 'es':
        return 'Piso/Unidad';
      case 'en':
      default:
        return 'Apt/Unit';
    }
  }

  String get recent_addresses {
    switch (locale.languageCode) {
      case 'es':
        return 'Direcciones Recientes';
      case 'en':
      default:
        return 'Recent Addresses';
    }
  }

  String get delivery_same_as_pickup {
    switch (locale.languageCode) {
      case 'es':
        return 'La dirección de entrega es la misma';
      case 'en':
      default:
        return 'Delivery address is the same as pickup';
    }
  }

  String get delivery_address {
    switch (locale.languageCode) {
      case 'es':
        return 'Dirección de Entrega';
      case 'en':
      default:
        return 'Delivery Address';
    }
  }

  String get schedule_pickup_title {
    switch (locale.languageCode) {
      case 'es':
        return 'Seleccionar Horario de Recogida';
      case 'en':
      default:
        return 'Select Pickup Schedule';
    }
  }

  String get select_pickup_date {
    switch (locale.languageCode) {
      case 'es':
        return 'Seleccionar Fecha de Recogida';
      case 'en':
      default:
        return 'Select Pickup Date';
    }
  }

  String get select_time_slot {
    switch (locale.languageCode) {
      case 'es':
        return 'Seleccionar Hora';
      case 'en':
      default:
        return 'Select Time Slot';
    }
  }

  String get select_services_title {
    switch (locale.languageCode) {
      case 'es':
        return 'Seleccionar Servicios';
      case 'en':
      default:
        return 'Select Services';
    }
  }

  String get order_summary_title {
    switch (locale.languageCode) {
      case 'es':
        return 'Resumen del Pedido';
      case 'en':
      default:
        return 'Order Summary';
    }
  }

  String get address_entry_title {
    switch (locale.languageCode) {
      case 'es':
        return 'Ingrese su Dirección';
      case 'en':
      default:
        return 'Enter Your Address';
    }
  }

  String get tap_to_search_address {
    switch (locale.languageCode) {
      case 'es':
        return 'Toque para buscar una dirección';
      case 'en':
      default:
        return 'Tap to search for an address';
    }
  }

  // Step Progress Bar
  String get step_of {
    switch (locale.languageCode) {
      case 'es':
        return 'Paso';
      case 'en':
      default:
        return 'Step';
    }
  }

  String get step_divider {
    switch (locale.languageCode) {
      case 'es':
        return 'de';
      case 'en':
      default:
        return 'of';
    }
  }

  // Personal Information Screen
  String get personal_information_title {
    switch (locale.languageCode) {
      case 'es':
        return 'Información Personal';
      case 'en':
      default:
        return 'Personal Information';
    }
  }

  String get first_name {
    switch (locale.languageCode) {
      case 'es':
        return 'Nombre';
      case 'en':
      default:
        return 'First Name';
    }
  }

  String get last_name {
    switch (locale.languageCode) {
      case 'es':
        return 'Apellido';
      case 'en':
      default:
        return 'Last Name';
    }
  }

  String get phone_number {
    switch (locale.languageCode) {
      case 'es':
        return 'Número de Teléfono';
      case 'en':
      default:
        return 'Phone Number';
    }
  }

  String get email {
    switch (locale.languageCode) {
      case 'es':
        return 'Correo Electrónico';
      case 'en':
      default:
        return 'Email';
    }
  }

  String get city {
    switch (locale.languageCode) {
      case 'es':
        return 'Ciudad';
      case 'en':
      default:
        return 'City';
    }
  }

  String get zip_code {
    switch (locale.languageCode) {
      case 'es':
        return 'Código Postal';
      case 'en':
      default:
        return 'Zip Code';
    }
  }

  String get optional {
    switch (locale.languageCode) {
      case 'es':
        return 'Opcional';
      case 'en':
      default:
        return 'Optional';
    }
  }

  // Validation Messages
  String get please_enter_first_name {
    switch (locale.languageCode) {
      case 'es':
        return 'Por favor ingrese su nombre';
      case 'en':
      default:
        return 'Please enter your first name';
    }
  }

  String get please_enter_last_name {
    switch (locale.languageCode) {
      case 'es':
        return 'Por favor ingrese su apellido';
      case 'en':
      default:
        return 'Please enter your last name';
    }
  }

  String get please_enter_phone {
    switch (locale.languageCode) {
      case 'es':
        return 'Por favor ingrese su número de teléfono';
      case 'en':
      default:
        return 'Please enter your phone number';
    }
  }

  String get please_enter_email {
    switch (locale.languageCode) {
      case 'es':
        return 'Por favor ingrese su correo electrónico';
      case 'en':
      default:
        return 'Please enter your email';
    }
  }

  String get please_enter_valid_email {
    switch (locale.languageCode) {
      case 'es':
        return 'Por favor ingrese un correo electrónico válido';
      case 'en':
      default:
        return 'Please enter a valid email';
    }
  }

  String get please_enter_street_address {
    switch (locale.languageCode) {
      case 'es':
        return 'Por favor ingrese una dirección';
      case 'en':
      default:
        return 'Please enter a street address';
    }
  }

  String get please_enter_city {
    switch (locale.languageCode) {
      case 'es':
        return 'Por favor ingrese una ciudad';
      case 'en':
      default:
        return 'Please enter a city';
    }
  }

  String get please_enter_zip_code {
    switch (locale.languageCode) {
      case 'es':
        return 'Por favor ingrese un código postal';
      case 'en':
      default:
        return 'Please enter a zip code';
    }
  }

  // Service Selection Screen
  String get order_summary {
    switch (locale.languageCode) {
      case 'es':
        return 'Resumen del Pedido';
      case 'en':
      default:
        return 'Order Summary';
    }
  }

  String get subtotal {
    switch (locale.languageCode) {
      case 'es':
        return 'Subtotal';
      case 'en':
      default:
        return 'Subtotal';
    }
  }

  String get item {
    switch (locale.languageCode) {
      case 'es':
        return 'artículo';
      case 'en':
      default:
        return 'item';
    }
  }

  String get items {
    switch (locale.languageCode) {
      case 'es':
        return 'artículos';
      case 'en':
      default:
        return 'items';
    }
  }

  String get no_items_selected {
    switch (locale.languageCode) {
      case 'es':
        return 'No hay artículos seleccionados';
      case 'en':
      default:
        return 'No items selected';
    }
  }

  String get cancel {
    switch (locale.languageCode) {
      case 'es':
        return 'Cancelar';
      case 'en':
      default:
        return 'Cancel';
    }
  }

  String get select_extras {
    switch (locale.languageCode) {
      case 'es':
        return 'Seleccionar Extras';
      case 'en':
      default:
        return 'Select Extras';
    }
  }

  String get no_extras_available {
    switch (locale.languageCode) {
      case 'es':
        return 'No hay extras disponibles para los artículos seleccionados.';
      case 'en':
      default:
        return 'No extras available for selected items.';
    }
  }

  String get back {
    switch (locale.languageCode) {
      case 'es':
        return 'Atrás';
      case 'en':
      default:
        return 'Back';
    }
  }

  String get add_to_order {
    switch (locale.languageCode) {
      case 'es':
        return 'Agregar al Pedido';
      case 'en':
      default:
        return 'Add to Order';
    }
  }

  // Order Summary Screen
  String get pickup_and_delivery {
    switch (locale.languageCode) {
      case 'es':
        return 'Recogida y Entrega';
      case 'en':
      default:
        return 'Pickup & Delivery';
    }
  }

  String get pickup_address_summary {
    switch (locale.languageCode) {
      case 'es':
        return 'Dirección de Recogida';
      case 'en':
      default:
        return 'Pickup Address';
    }
  }

  String get delivery_address_label {
    switch (locale.languageCode) {
      case 'es':
        return 'Dirección de Entrega';
      case 'en':
      default:
        return 'Delivery Address';
    }
  }

  String get pickup_date {
    switch (locale.languageCode) {
      case 'es':
        return 'Fecha de Recogida';
      case 'en':
      default:
        return 'Pickup Date';
    }
  }

  String get pickup_time {
    switch (locale.languageCode) {
      case 'es':
        return 'Hora de Recogida';
      case 'en':
      default:
        return 'Pickup Time';
    }
  }

  String get order_details {
    switch (locale.languageCode) {
      case 'es':
        return 'Detalles del Pedido';
      case 'en':
      default:
        return 'Order Details';
    }
  }

  String get special_instructions {
    switch (locale.languageCode) {
      case 'es':
        return 'Instrucciones Especiales';
      case 'en':
      default:
        return 'Special Instructions';
    }
  }

  String get payment_summary {
    switch (locale.languageCode) {
      case 'es':
        return 'Resumen de Pago';
      case 'en':
      default:
        return 'Payment Summary';
    }
  }

  String get pickup_delivery_fee {
    switch (locale.languageCode) {
      case 'es':
        return 'Recogida y Entrega';
      case 'en':
      default:
        return 'Pickup & Delivery';
    }
  }

  String get tax {
    switch (locale.languageCode) {
      case 'es':
        return 'Impuesto';
      case 'en':
      default:
        return 'Tax';
    }
  }

  String get total {
    switch (locale.languageCode) {
      case 'es':
        return 'Total';
      case 'en':
      default:
        return 'Total';
    }
  }

  String get name {
    switch (locale.languageCode) {
      case 'es':
        return 'Nombre';
      case 'en':
      default:
        return 'Name';
    }
  }

  String get phone {
    switch (locale.languageCode) {
      case 'es':
        return 'Teléfono';
      case 'en':
      default:
        return 'Phone';
    }
  }

  String get not_selected {
    switch (locale.languageCode) {
      case 'es':
        return 'No seleccionado';
      case 'en':
      default:
        return 'Not selected';
    }
  }

  String get not_provided {
    switch (locale.languageCode) {
      case 'es':
        return 'No proporcionado';
      case 'en':
      default:
        return 'Not provided';
    }
  }

  String get same_as_pickup_address {
    switch (locale.languageCode) {
      case 'es':
        return 'Misma que la dirección de recogida';
      case 'en':
      default:
        return 'Same as pickup address';
    }
  }

  String get none {
    switch (locale.languageCode) {
      case 'es':
        return 'Ninguna';
      case 'en':
      default:
        return 'None';
    }
  }

  // Main Flow Screen
  String get confirm_place_order {
    switch (locale.languageCode) {
      case 'es':
        return 'Confirmar y Realizar Pedido';
      case 'en':
      default:
        return 'Confirm & Place Order';
    }
  }

  // Schedule Picker Screen
  String get selected_date {
    switch (locale.languageCode) {
      case 'es':
        return 'Fecha Seleccionada';
      case 'en':
      default:
        return 'Selected Date';
    }
  }

  String get selected_time {
    switch (locale.languageCode) {
      case 'es':
        return 'Hora Seleccionada';
      case 'en':
      default:
        return 'Selected Time';
    }
  }

  String get special_instructions_optional {
    switch (locale.languageCode) {
      case 'es':
        return 'Instrucciones Especiales (Opcional)';
      case 'en':
      default:
        return 'Special Instructions (Optional)';
    }
  }

  String get special_instructions_hint {
    switch (locale.languageCode) {
      case 'es':
        return 'ej., tocar timbre, código de puerta, etc.';
      case 'en':
      default:
        return 'e.g., ring doorbell, gate code, etc.';
    }
  }

  String get no_available_slots {
    switch (locale.languageCode) {
      case 'es':
        return 'No hay horarios disponibles.';
      case 'en':
      default:
        return 'No available slots.';
    }
  }

  String get edit {
    switch (locale.languageCode) {
      case 'es':
        return 'Editar';
      case 'en':
      default:
        return 'Edit';
    }
  }

  String get clear_cart {
    switch (locale.languageCode) {
      case 'es':
        return 'Vaciar Carrito';
      case 'en':
      default:
        return 'Clear Cart';
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
