// Purpose: The entry point of the application. It will initialize the app and services.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';

import 'config/theme.dart';
import 'state/order_provider.dart';
import 'screens/main_flow_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderProvider(),
      child: MaterialApp(
          title: 'Dry Cleaning App',
          theme: AppTheme.lightTheme,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('es', ''), // Spanish, no country code
            Locale('en', ''), // English, no country code
          ],
          home: const MainFlowScreen()),
    );
  }
}
