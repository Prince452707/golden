import 'api_config.dart';

/// Golden Digital Precious Metals Platform - API Constants & Endpoints
/// Conforms to API Specification Document Version 1.0.0
class ApiConstants {
  /// The ONLY API Base URL for the platform
  static String get baseUrl => ApiConfig.baseUrl;

  static String get activeBaseUrl => ApiConfig.baseUrl;

  // 1. Auth & Identity Endpoints
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String userProfile = '/user/profile';
  static const String submitKyc = '/user/kyc/submit';

  // 2. Live Rates & Price History Endpoints
  static const String liveRates = '/rates/live';
  static const String lockQuote = '/rates/lock-quote';
  static const String priceHistory = '/rates/history';

  // 3. Buy Orders & Checkout Endpoints
  static const String buyCalculate = '/orders/buy/calculate';
  static const String buyInitiate = '/orders/buy/initiate';
  static const String buyConfirm = '/orders/buy/confirm';

  // 4. Sell Orders & IMPS Payout Endpoints
  static const String sellCalculate = '/orders/sell/calculate';
  static const String sellInitiate = '/orders/sell/initiate';

  // 5. Gullak Micro-Savings Endpoints
  static const String gullakCatalog = '/gullak/catalog';
  static const String gullakGoals = '/gullak/goals';
  static String gullakDeposit(String goalId) => '/gullak/goals/$goalId/deposit';

  // 6. Portfolio Analytics Endpoints
  static const String portfolioSummary = '/portfolio/summary';
  static String portfolioMetal(String metalType) => '/portfolio/metal/$metalType';

  // 7. Transactions & Invoicing Endpoints
  static const String transactions = '/transactions';
  static String transactionInvoice(String id) => '/transactions/$id/invoice';

  // 8. Banking Endpoints
  static const String bankAccounts = '/bank-accounts';

  // 9. Referral & Rewards Endpoints
  static const String referralMyCode = '/referrals/my-code';
  static const String rewards = '/rewards';

  // 10. Support & Trust Endpoints
  static const String supportTicket = '/support/ticket';
  static const String supportFaqs = '/support/faqs';
}
