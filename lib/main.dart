import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'data/services/notification_service.dart';

import 'state/app_state.dart';
import 'state/auth_provider.dart';
import 'state/settings_provider.dart';
import 'state/budget_provider.dart';
import 'state/transaction_provider.dart';
import 'state/category_provider.dart';
import 'state/saving_goals_provider.dart';
import 'app/routes.dart';
import 'app/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => SavingGoalsProvider()),
      ],
      child: const UniSpendApp(),
    ),
  );
}

class UniSpendApp extends StatelessWidget {
  const UniSpendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'UniSpend',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode:
              settingsProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          routerConfig: router,
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: ScrollBehavior().copyWith(
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
