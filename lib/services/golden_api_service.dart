import 'dart:async';
import '../core/api/api_client.dart';
import '../core/api/api_constants.dart';
import '../core/api/api_response.dart';
import '../core/models/user_model.dart';
import '../core/models/rate_models.dart';
import '../core/models/order_models.dart';
import '../core/models/gullak_models.dart';
import '../core/models/portfolio_models.dart';
import '../core/models/transaction_models.dart';
import '../core/models/bank_model.dart';
import '../core/models/reward_referral_models.dart';
import '../core/models/support_model.dart';
import '../core/storage/secure_token_storage.dart';


class GoldenApiService {
  static final GoldenApiService instance = GoldenApiService._internal();
  factory GoldenApiService() => instance;
  GoldenApiService._internal();

  final ApiClient _client = ApiClient();

  UserModel? currentUser;
  LiveRatesData? latestRates;

  /// Configure authentication token in the HTTP client
  void setAuthToken(String token) {
    _client.setAuthToken(token);
  }

  /// Clear in-memory user and token session
  void clearSession() {
    currentUser = null;
    _client.clearAuthToken();
  }

  /// Full logout: wipes secure storage and resets local state
  Future<void> logout() async {
    clearSession();
    await SecureTokenStorage.instance.clearAuth();
  }

  /// Restore user session from secure storage and refresh with backend
  Future<UserModel?> restoreUserSession() async {
    final cached = await SecureTokenStorage.instance.getUser();
    if (cached != null) {
      currentUser = cached;
    }

    try {
      final res = await getUserProfile();
      if (res.success && res.data != null) {
        currentUser = res.data;
        await SecureTokenStorage.instance.saveUser(currentUser!);
        return currentUser;
      }
    } catch (_) {}

    return currentUser;
  }

  
  StreamController<LiveRatesData>? _rateStreamController;
  Timer? _pollingTimer;

  Stream<LiveRatesData> get liveRateStream {
    _rateStreamController ??= StreamController<LiveRatesData>.broadcast(
      onListen: _startLiveRatePolling,
      onCancel: _stopLiveRatePolling,
    );
    return _rateStreamController!.stream;
  }

  void _startLiveRatePolling() {
    getLiveRates();
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      final res = await getLiveRates();
      if (res.success && res.data != null) {
        _rateStreamController?.add(res.data!);
      }
    });
  }

  void _stopLiveRatePolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }


  Future<ApiResponse<Map<String, dynamic>>> sendOtp(
    String phoneNumber, {
    String countryCode = '+91',
  }) async {
    return _client.post<Map<String, dynamic>>(
      ApiConstants.sendOtp,
      body: {
        'phoneNumber': phoneNumber,
        'countryCode': countryCode,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  /// Verify Mobile OTP and establish session
  Future<ApiResponse<UserModel>> verifyOtp(
    String phoneNumber,
    String otp, {
    String countryCode = '+91',
  }) async {
    final res = await _client.post<Map<String, dynamic>>(
      ApiConstants.verifyOtp,
      body: {
        'phoneNumber': phoneNumber,
        'countryCode': countryCode,
        'otp': otp,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );

    if (res.success && res.data != null) {
      final userData = res.data!['user'] as Map<String, dynamic>? ?? {};
      final token = res.data!['token'] as String?;
      final isNewUser = (res.data!['isNewUser'] as bool?) ??
          (userData['isNewUser'] as bool?) ??
          (res.data!['is_new_user'] as bool?) ??
          (userData['is_new_user'] as bool?) ??
          false;

      if (token != null) {
        _client.setAuthToken(token);
        await SecureTokenStorage.instance.saveToken(token);
      }

      currentUser = UserModel.fromJson({
        ...userData,
        'isNewUser': isNewUser,
      });

      // If OTP response did not have a custom name and user is not explicitly new,
      // verify against /user/profile so existing users are never incorrectly asked
      if (!currentUser!.hasProfileData && !isNewUser) {
        try {
          final profileRes = await getUserProfile();
          if (profileRes.success && profileRes.data != null) {
            currentUser = profileRes.data!.copyWith(isNewUser: isNewUser);
          }
        } catch (_) {}
      }

      if (currentUser != null) {
        await SecureTokenStorage.instance.saveUser(currentUser!);
      }

      return ApiResponse<UserModel>(
        success: true,
        message: res.message,
        timestamp: res.timestamp,
        data: currentUser,
      );
    }

    return ApiResponse<UserModel>(
      success: false,
      message: res.message,
      timestamp: res.timestamp,
      errorCode: res.errorCode,
    );
  }

  /// Get Current User Profile
  Future<ApiResponse<UserModel>> getUserProfile() async {
    final res = await _client.get<UserModel>(
      ApiConstants.userProfile,
      fromJson: (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );
    if (res.success && res.data != null) {
      currentUser = res.data;
    }
    return res;
  }

  /// Update User Profile Details (Full Name, Email, State, City, Referral)
  Future<ApiResponse<UserModel>> updateProfile({
    required String fullName,
    String? email,
    String? state,
    String? city,
    String? referralCode,
  }) async {
    final body = <String, dynamic>{
      'fullName': fullName,
      if (email != null && email.isNotEmpty) 'email': email,
      if (state != null && state.isNotEmpty) 'state': state,
      if (city != null && city.isNotEmpty) 'city': city,
      if (referralCode != null && referralCode.isNotEmpty) 'referralCode': referralCode,
    };

    final res = await _client.put<UserModel>(
      ApiConstants.userProfile,
      body: body,
      fromJson: (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );

    if (res.success && res.data != null) {
      currentUser = res.data;
      await SecureTokenStorage.instance.saveUser(currentUser!);
      return res;
    }

  // Atomic fallback: update local user model in memory
    if (currentUser != null) {
      currentUser = currentUser!.copyWith(
        fullName: fullName,
        email: email ?? currentUser!.email,
        state: state ?? currentUser!.state,
        city: city ?? currentUser!.city,
        isNewUser: false,
      );
      await SecureTokenStorage.instance.saveUser(currentUser!);
      return ApiResponse<UserModel>(
        success: true,
        message: res.message.isNotEmpty ? res.message : 'Profile details saved successfully',
        timestamp: DateTime.now().toIso8601String(),
        data: currentUser,
      );
    }

    return res;
  }

 
  Future<ApiResponse<Map<String, dynamic>>> submitKyc({
    required String panNumber,
    required String aadhaarNumber,
  }) async {
    final res = await _client.post<Map<String, dynamic>>(
      ApiConstants.submitKyc,
      body: {
        'panNumber': panNumber,
        'aadhaarNumber': aadhaarNumber,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );

    if (res.success && currentUser != null) {
      currentUser = currentUser!.copyWith(
        kycStatus: 'verified',
        panNumber: panNumber,
        aadhaarNumber: '•••• •••• ${aadhaarNumber.length >= 4 ? aadhaarNumber.substring(aadhaarNumber.length - 4) : aadhaarNumber}',
      );
    }
    return res;
  }


  Future<ApiResponse<LiveRatesData>> getLiveRates() async {
    final res = await _client.get<LiveRatesData>(
      ApiConstants.liveRates,
      fromJson: (data) => LiveRatesData.fromJson(data as Map<String, dynamic>),
    );
    if (res.success && res.data != null) {
      latestRates = res.data;
      _rateStreamController?.add(latestRates!);
    }
    return res;
  }

  /// Lock Buy Rate for 5 Minutes to avoid checkout slippage
  Future<ApiResponse<LockQuoteModel>> lockPriceQuote({String metal = 'gold'}) async {
    return _client.post<LockQuoteModel>(
      ApiConstants.lockQuote,
      body: {'metal': metal},
      fromJson: (data) => LockQuoteModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Historical Pricing Trajectory (1D, 1W, 1M, 6M, 1Y, ALL)
  Future<ApiResponse<PriceHistoryModel>> getPriceHistory({
    String metal = 'gold',
    String range = '6M',
  }) async {
    return _client.get<PriceHistoryModel>(
      ApiConstants.priceHistory,
      queryParams: {'metal': metal, 'range': range},
      fromJson: (data) => PriceHistoryModel.fromJson(data as Map<String, dynamic>),
    );
  }

  // ==========================================
  // MODULE 3: BULLION BUY ORDERS & CHECKOUT
  // ==========================================

  /// Calculate Buy Quote with 3% GST & Free Brink's Vaulting
  Future<ApiResponse<BuyCalculationModel>> calculateBuyQuote({
    String metal = 'gold',
    double? amount,
    double? grams,
    String? quoteId,
  }) async {
    final body = <String, dynamic>{'metal': metal};
    if (amount != null) body['amount'] = amount;
    if (grams != null) body['grams'] = grams;
    if (quoteId != null) body['quoteId'] = quoteId;

    return _client.post<BuyCalculationModel>(
      ApiConstants.buyCalculate,
      body: body,
      fromJson: (data) => BuyCalculationModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Initiate Buy Order & Obtain Dynamic UPI Intent
  Future<ApiResponse<BuyInitiatedModel>> initiateBuyOrder({
    required String metal,
    required double amount,
    String paymentMethod = 'UPI',
    String? goalName,
  }) async {
    final body = <String, dynamic>{
      'metal': metal,
      'amount': amount,
      'paymentMethod': paymentMethod,
    };
    if (goalName != null) body['goalName'] = goalName;

    return _client.post<BuyInitiatedModel>(
      ApiConstants.buyInitiate,
      body: body,
      fromJson: (data) => BuyInitiatedModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Confirm Buy Order & Credit Grams to Physical Vault
  Future<ApiResponse<BuyConfirmedModel>> confirmBuyOrder({
    required String orderId,
    String? paymentTransactionId,
  }) async {
    final res = await _client.post<BuyConfirmedModel>(
      ApiConstants.buyConfirm,
      body: {
        'orderId': orderId,
        'paymentTransactionId': paymentTransactionId ?? 'UPI-TXN-${DateTime.now().millisecondsSinceEpoch}',
      },
      fromJson: (data) => BuyConfirmedModel.fromJson(data as Map<String, dynamic>),
    );

    if (res.success && res.data != null && currentUser != null) {
      // Update in-memory user balances atomically
      currentUser = currentUser!.copyWith(
        goldVaultBalanceGrams: res.data!.goldVaultBalance,
        silverVaultBalanceGrams: res.data!.silverVaultBalance,
        totalGoldInvestedAmount: currentUser!.totalGoldInvestedAmount + res.data!.amount,
      );
    }
    return res;
  }

  // ==========================================
  // MODULE 4: BULLION SELL & INSTANT WITHDRAWAL
  // ==========================================

  /// Calculate Sell Payout at Live Selling Rate
  Future<ApiResponse<SellCalculationModel>> calculateSellQuote({
    String metal = 'gold',
    required double grams,
  }) async {
    return _client.post<SellCalculationModel>(
      ApiConstants.sellCalculate,
      body: {
        'metal': metal,
        'grams': grams,
      },
      fromJson: (data) => SellCalculationModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Execute Sell & Instant IMPS Bank Transfer
  Future<ApiResponse<SellInitiatedModel>> initiateSellOrder({
    String metal = 'gold',
    required double grams,
    String? bankAccountId,
  }) async {
    final body = <String, dynamic>{
      'metal': metal,
      'grams': grams,
    };
    if (bankAccountId != null) body['bankAccountId'] = bankAccountId;

    final res = await _client.post<SellInitiatedModel>(
      ApiConstants.sellInitiate,
      body: body,
      fromJson: (data) => SellInitiatedModel.fromJson(data as Map<String, dynamic>),
    );

    if (res.success && res.data != null && currentUser != null) {
      currentUser = currentUser!.copyWith(
        goldVaultBalanceGrams: res.data!.remainingGoldGrams,
        silverVaultBalanceGrams: res.data!.remainingSilverGrams,
      );
    }
    return res;
  }

 

 
  Future<ApiResponse<List<GullakCatalogItem>>> getGullakCatalog() async {
    return _client.get<List<GullakCatalogItem>>(
      ApiConstants.gullakCatalog,
      fromJson: (data) {
        final list = data as List<dynamic>? ?? [];
        return list.map((item) => GullakCatalogItem.fromJson(item as Map<String, dynamic>)).toList();
      },
    );
  }


  Future<ApiResponse<UserGoalsData>> getUserGoals() async {
    return _client.get<UserGoalsData>(
      ApiConstants.gullakGoals,
      fromJson: (data) => UserGoalsData.fromJson(data as Map<String, dynamic>),
    );
  }

  
  Future<ApiResponse<GullakGoalModel>> createGullakGoal({
    required String title,
    required double targetAmount,
    String categoryId = 'custom',
    String frequency = 'Monthly',
    double initialDeposit = 0.0,
    bool autoDebitEnabled = false,
    double autoDebitAmount = 0.0,
  }) async {
    return _client.post<GullakGoalModel>(
      ApiConstants.gullakGoals,
      body: {
        'title': title,
        'targetAmount': targetAmount,
        'categoryId': categoryId,
        'frequency': frequency,
        'initialDeposit': initialDeposit,
        'autoDebitEnabled': autoDebitEnabled,
        'autoDebitAmount': autoDebitAmount,
      },
      fromJson: (data) => GullakGoalModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Instant Deposit to a Specific Gullak Goal
  Future<ApiResponse<Map<String, dynamic>>> depositToGoal(
    String goalId,
    double amount,
  ) async {
    return _client.post<Map<String, dynamic>>(
      ApiConstants.gullakDeposit(goalId),
      body: {'amount': amount},
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  // ==========================================
  // MODULE 6: PORTFOLIO ANALYTICS
  // ==========================================

  /// Aggregated Portfolio Valuation & 6-Month Benchmark
  Future<ApiResponse<PortfolioSummaryModel>> getPortfolioSummary() async {
    return _client.get<PortfolioSummaryModel>(
      ApiConstants.portfolioSummary,
      fromJson: (data) => PortfolioSummaryModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Itemized Metal Holdings with Active Goal Segregation
  Future<ApiResponse<MetalHoldingsModel>> getMetalHoldings(String metalType) async {
    return _client.get<MetalHoldingsModel>(
      ApiConstants.portfolioMetal(metalType),
      fromJson: (data) => MetalHoldingsModel.fromJson(data as Map<String, dynamic>),
    );
  }


  Future<ApiResponse<TransactionsLedgerData>> getTransactions({
    String type = 'All',
    String metal = 'all',
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    final query = <String, String>{
      'type': type,
      'metal': metal,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search != null && search.isNotEmpty) query['search'] = search;

    return _client.get<TransactionsLedgerData>(
      ApiConstants.transactions,
      queryParams: query,
      fromJson: (data) => TransactionsLedgerData.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Official GST Tax Invoice Details (HSN 7108/7106)
  Future<ApiResponse<DigitalInvoiceModel>> getTransactionInvoice(String id) async {
    return _client.get<DigitalInvoiceModel>(
      ApiConstants.transactionInvoice(id),
      fromJson: (data) => DigitalInvoiceModel.fromJson(data as Map<String, dynamic>),
    );
  }

  // ==========================================
  // MODULE 8: BANKING & PAYOUT ACCOUNTS
  // ==========================================

  /// Get Linked Bank Accounts
  Future<ApiResponse<List<BankAccountModel>>> getBankAccounts() async {
    return _client.get<List<BankAccountModel>>(
      ApiConstants.bankAccounts,
      fromJson: (data) {
        if (data is List) {
          return data.map((b) => BankAccountModel.fromJson(b as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
  }

  /// Link Verified Bank Account for IMPS Payouts
  Future<ApiResponse<BankAccountModel>> linkBankAccount({
    required String bankName,
    required String accountNumber,
    required String ifscCode,
    required String accountHolderName,
    String accountType = 'Savings',
    bool isPrimary = true,
  }) async {
    return _client.post<BankAccountModel>(
      ApiConstants.bankAccounts,
      body: {
        'bankName': bankName,
        'accountNumber': accountNumber,
        'ifscCode': ifscCode,
        'accountHolderName': accountHolderName,
        'accountType': accountType,
        'isPrimary': isPrimary,
      },
      fromJson: (data) => BankAccountModel.fromJson(data as Map<String, dynamic>),
    );
  }

  // ==========================================
  // MODULE 9: REFERRALS & REWARDS
  // ==========================================

  /// Referral Code, Share Link & ₹1,000 Bonus Stats
  Future<ApiResponse<ReferralDataModel>> getReferralStats() async {
    return _client.get<ReferralDataModel>(
      ApiConstants.referralMyCode,
      fromJson: (data) => ReferralDataModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Scratch Cards & Bullion Bonus Unlocks
  Future<ApiResponse<RewardsEnvelopeModel>> getRewards() async {
    return _client.get<RewardsEnvelopeModel>(
      ApiConstants.rewards,
      fromJson: (data) => RewardsEnvelopeModel.fromJson(data as Map<String, dynamic>),
    );
  }


  Future<ApiResponse<SupportTicketModel>> createSupportTicket({
    required String subject,
    required String message,
    String category = 'Vault & Delivery',
  }) async {
    return _client.post<SupportTicketModel>(
      ApiConstants.supportTicket,
      body: {
        'subject': subject,
        'message': message,
        'category': category,
      },
      fromJson: (data) => SupportTicketModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Get Institutional Trust Badges & Verified FAQs
  Future<ApiResponse<TrustFaqsDataModel>> getTrustFaqs() async {
    return _client.get<TrustFaqsDataModel>(
      ApiConstants.supportFaqs,
      fromJson: (data) => TrustFaqsDataModel.fromJson(data as Map<String, dynamic>),
    );
  }
}

