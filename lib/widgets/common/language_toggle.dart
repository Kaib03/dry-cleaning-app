import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/locale_provider.dart';
import 'dart:ui';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isSpanish = localeProvider.locale.languageCode == 'es';

    return ToggleButtons(
      isSelected: [isSpanish, !isSpanish],
      onPressed: (index) {
        if (index == 0 && !isSpanish) {
          localeProvider.setLocale(const Locale('es'));
        } else if (index == 1 && isSpanish) {
          localeProvider.setLocale(const Locale('en'));
        }
      },
      borderRadius: BorderRadius.circular(8.0),
      selectedColor: Colors.white,
      fillColor: Theme.of(context).primaryColor,
      color: Theme.of(context).primaryColor,
      constraints: const BoxConstraints(minHeight: 30.0, minWidth: 40.0),
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('ES'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('EN'),
        ),
      ],
    );
  }
}
