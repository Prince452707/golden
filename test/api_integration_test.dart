import 'package:flutter_test/flutter_test.dart';
import 'package:golden/services/golden_api_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Golden Digital Precious Metals - API Integration Tests', () {
    final service = GoldenApiService.instance;

    test('Module 1: Auth & Identity (Send OTP, Verify OTP, Profile, KYC)', () async {
      // 1. Send OTP
      final sendOtpRes = await service.sendOtp('9876543210', countryCode: '+91');
      expect(sendOtpRes.success, isTrue);
      expect(sendOtpRes.data?['demoOtp'], equals('123456'));

      // 2. Verify OTP
      final verifyRes = await service.verifyOtp('9876543210', '123456');
      expect(verifyRes.success, isTrue);
      expect(verifyRes.data?.fullName, equals('Prince Kumar'));
      expect(verifyRes.data?.goldVaultBalanceGrams, equals(0.8474));

      // 3. User Profile
      final profileRes = await service.getUserProfile();
      expect(profileRes.success, isTrue);
      expect(profileRes.data?.referralCode, equals('GOLD777999'));

      // 4. Submit KYC
      final kycRes = await service.submitKyc(panNumber: 'ABCDE1234F', aadhaarNumber: '123456789012');
      expect(kycRes.success, isTrue);
      expect(kycRes.data?['kycStatus'], equals('verified'));
    });

    test('Module 2: Live Rates & Market Data', () async {
      // 1. Live Rates
      final ratesRes = await service.getLiveRates();
      expect(ratesRes.success, isTrue);
      expect(ratesRes.data?.gold.buyPricePerGram, equals(14370.2));
      expect(ratesRes.data?.silver.buyPricePerGram, equals(92.14));

      // 2. 5-Minute Price Lock Quote
      final lockRes = await service.lockPriceQuote(metal: 'gold');
      expect(lockRes.success, isTrue);
      expect(lockRes.data?.durationSeconds, equals(300));
      expect(lockRes.data?.quoteId, isNotEmpty);

      // 3. Price History Trajectory
      final historyRes = await service.getPriceHistory(metal: 'gold', range: '6M');
      expect(historyRes.success, isTrue);
      expect(historyRes.data?.timeframe, equals('6M'));
      expect(historyRes.data?.points.length, greaterThan(0));
    });

    test('Module 3: Bullion Buy Orders & Checkout Pipeline', () async {
      // 1. Buy Calculation
      final calcRes = await service.calculateBuyQuote(metal: 'gold', amount: 10000);
      expect(calcRes.success, isTrue);
      expect(calcRes.data?.totalPayableAmount, equals(10000));
      expect(calcRes.data?.gstPercentage, equals(3.0));

      // 2. Initiate Buy Order
      final initRes = await service.initiateBuyOrder(metal: 'gold', amount: 10000);
      expect(initRes.success, isTrue);
      expect(initRes.data?.orderId, startsWith('GLD-BUY-'));
      expect(initRes.data?.upiIntent, contains('upi://pay'));

      // 3. Confirm Buy Order
      final confirmRes = await service.confirmBuyOrder(orderId: initRes.data!.orderId);
      expect(confirmRes.success, isTrue);
      expect(confirmRes.data?.destination, equals("Brink's Secure Physical Vault"));
      expect(confirmRes.data?.goldVaultBalance, equals(1.5433));
    });

    test('Module 4: Bullion Sell & IMPS Payout', () async {
      // 1. Sell Calculation
      final calcRes = await service.calculateSellQuote(metal: 'gold', grams: 0.5);
      expect(calcRes.success, isTrue);
      expect(calcRes.data?.netPayoutAmount, equals(7051.15));

      // 2. Initiate Sell Order
      final sellRes = await service.initiateSellOrder(metal: 'gold', grams: 0.5);
      expect(sellRes.success, isTrue);
      expect(sellRes.data?.orderId, startsWith('GLD-SELL-'));
      expect(sellRes.data?.destinationAccount, contains('HDFC Bank'));
    });

    test('Module 5: Gullak Micro-Savings Engine', () async {
      // 1. Catalog
      final catRes = await service.getGullakCatalog();
      expect(catRes.success, isTrue);
      expect(catRes.data?.length, greaterThan(0));

      // 2. User Goals
      final goalsRes = await service.getUserGoals();
      expect(goalsRes.success, isTrue);
      expect(goalsRes.data?.goals.length, equals(2));

      // 3. Create Goal
      final createRes = await service.createGullakGoal(
        title: 'Europe Trip',
        targetAmount: 75000,
        initialDeposit: 500,
      );
      expect(createRes.success, isTrue);
      expect(createRes.data?.title, equals('Europe Trip'));

      // 4. Deposit
      final depRes = await service.depositToGoal(createRes.data!.id, 1000);
      expect(depRes.success, isTrue);
    });

    test('Module 6: Portfolio Analytics', () async {
      final summaryRes = await service.getPortfolioSummary();
      expect(summaryRes.success, isTrue);
      expect(summaryRes.data?.totalPortfolioValue, equals(15448.28));

      final metalRes = await service.getMetalHoldings('gold');
      expect(metalRes.success, isTrue);
      expect(metalRes.data?.allocatedGrams, equals(0.78));
      expect(metalRes.data?.freeUnallocatedGrams, equals(0.0674));
    });

    test('Module 7: Transactions & Tax Invoice', () async {
      final txRes = await service.getTransactions();
      expect(txRes.success, isTrue);
      expect(txRes.data?.transactions.length, greaterThan(0));

      final invRes = await service.getTransactionInvoice('GLD-BUY-8924112');
      expect(invRes.success, isTrue);
      expect(invRes.data?.hsnCode, equals('7108'));
      expect(invRes.data?.sellerGstin, equals('07AAAAA0000A1Z5'));
    });

    test('Module 8: Banking Accounts', () async {
      final bankRes = await service.linkBankAccount(
        bankName: 'HDFC Bank',
        accountNumber: '5010049284219',
        ifscCode: 'HDFC0000128',
        accountHolderName: 'Prince Kumar',
      );
      expect(bankRes.success, isTrue);
      expect(bankRes.data?.isVerified, isTrue);
    });

    test('Module 9: Referrals & Rewards', () async {
      final refRes = await service.getReferralStats();
      expect(refRes.success, isTrue);
      expect(refRes.data?.rewardPerReferral, equals(1000.0));

      final rewRes = await service.getRewards();
      expect(rewRes.success, isTrue);
      expect(rewRes.data?.activeScratchCardsCount, equals(2));
    });

    test('Module 10: 24/7 Gold Advisor & FAQs', () async {
      final ticketRes = await service.createSupportTicket(
        subject: 'Inquiry regarding 24K Gold Coin delivery',
        message: 'Delivery timeline to Delhi NCR',
      );
      expect(ticketRes.success, isTrue);
      expect(ticketRes.data?.status, equals('open'));

      final faqsRes = await service.getTrustFaqs();
      expect(faqsRes.success, isTrue);
      expect(faqsRes.data?.faqs.length, greaterThan(0));
      expect(faqsRes.data?.trustBadges.length, equals(4));
    });
  });
}

