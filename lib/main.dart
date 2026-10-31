import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/live_rates_screen.dart';
import 'screens/buy_screen.dart';
import 'screens/sell_screen.dart';
import 'screens/portfolio_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/price_history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/screen_showcase_shell.dart';
import 'screens/gullaks_screen.dart';
import 'screens/gullak_goals_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);


  SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
    if (systemOverlaysAreVisible) {
      Future.delayed(const Duration(seconds: 2), () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      });
    }
  });

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: false,
    ),
  );

  runApp(const GoldApp());
}

class GoldApp extends StatelessWidget {
  final Widget? home;

  const GoldApp({super.key, this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gold',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: home ?? const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/live_rates': (context) => const LiveRatesScreen(),
        '/buy': (context) => const BuyScreen(),
        '/sell': (context) => const SellScreen(),
        '/portfolio': (context) => const PortfolioScreen(),
        '/transactions': (context) => const TransactionsScreen(),
        '/price_history': (context) => const PriceHistoryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/signup': (context) => const SignupScreen(),
        '/showcase': (context) => const ScreenShowcaseShell(),
        '/gullaks': (context) => const GullaksScreen(),
        '/gullak_goals': (context) => const GullakGoalsScreen(),
      },
    );
  }
}
