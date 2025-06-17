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
