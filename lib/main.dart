import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/api/api_client.dart';
import 'services/golden_api_service.dart';
import 'screens/auth_gate.dart';
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


final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

bool _isHandlingSessionExpiry = false;

void _setupAuthInterceptor() {
  ApiClient().onUnauthorized = () async {
    if (_isHandlingSessionExpiry) return;
    _isHandlingSessionExpiry = true;

    try {
      await GoldenApiService.instance.logout();

      rootNavigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SignupScreen()),
        (route) => false,
      );

      rootScaffoldMessengerKey.currentState?.removeCurrentSnackBar();
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.lock_clock_outlined, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your session has expired. Please log in again.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        _isHandlingSessionExpiry = false;
      });
    }
  };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _setupAuthInterceptor();


  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
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
      navigatorKey: rootNavigatorKey,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      title: 'Gold',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: home ?? const AuthGate(),
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
