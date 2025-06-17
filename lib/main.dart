// Purpose: The entry point of the application. It will initialize the app and services.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';

import 'config/theme.dart';
import 'state/order_provider.dart';
import 'state/locale_provider.dart';
import 'screens/main_flow_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'Dry Cleaning App',
            theme: AppTheme.lightTheme,
            locale: localeProvider.locale, // Use the provider's locale
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('es', ''), // Spanish
              const Locale('en', ''), // English
            ],
            home: const MainFlowScreen(),
          );
        },
      ),
    );
  }
}
