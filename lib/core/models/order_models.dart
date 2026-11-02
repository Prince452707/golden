/// Buy Order Calculation Result Model
class BuyCalculationModel {
  final String metal;
  final double ratePerGram;
  final double grams;
  final double basePrice;
  final double gstPercentage;
  final double gstAmount;
  final double vaultFee;
  final String vaultFeeDescription;
  final double totalPayableAmount;

  BuyCalculationModel({
    required this.metal,
    required this.ratePerGram,
    required this.grams,
    required this.basePrice,
    required this.gstPercentage,
    required this.gstAmount,
    required this.vaultFee,
    required this.vaultFeeDescription,
    required this.totalPayableAmount,
  });

  factory BuyCalculationModel.fromJson(Map<String, dynamic> json) {
    return BuyCalculationModel(
      metal: (json['metal'] ?? 'gold') as String,
      ratePerGram: (json['ratePerGram'] as num?)?.toDouble() ?? 0.0,
      grams: (json['grams'] as num?)?.toDouble() ?? 0.0,
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
      gstPercentage: (json['gstPercentage'] as num?)?.toDouble() ?? 3.0,
      gstAmount: (json['gstAmount'] as num?)?.toDouble() ?? 0.0,
      vaultFee: (json['vaultFee'] as num?)?.toDouble() ?? 0.0,
      vaultFeeDescription: (json['vaultFeeDescription'] ?? "Brink's Secure Vaulting: FREE (Lifetime)") as String,
      totalPayableAmount: (json['totalPayableAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// Buy Order Initiated Intent Model
class BuyInitiatedModel {
  final String orderId;
  final String metal;
  final double amount;
  final double grams;
  final double ratePerGram;
  final double basePrice;
  final double gstAmount;
  final String paymentMethod;
  final String gatewayUrl;
  final String paymentOrderId;
  final String upiIntent;

  BuyInitiatedModel({
    required this.orderId,
    required this.metal,
    required this.amount,
    required this.grams,
    required this.ratePerGram,
    required this.basePrice,
    required this.gstAmount,
    required this.paymentMethod,
    required this.gatewayUrl,
    required this.paymentOrderId,
    required this.upiIntent,
  });

  factory BuyInitiatedModel.fromJson(Map<String, dynamic> json) {
    final pg = json['paymentGateway'] as Map<String, dynamic>? ?? {};
    return BuyInitiatedModel(
      orderId: (json['orderId'] ?? '') as String,
      metal: (json['metal'] ?? 'gold') as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      grams: (json['grams'] as num?)?.toDouble() ?? 0.0,
      ratePerGram: (json['ratePerGram'] as num?)?.toDouble() ?? 0.0,
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
      gstAmount: (json['gstAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: (json['paymentMethod'] ?? 'UPI') as String,
      gatewayUrl: (pg['gatewayUrl'] ?? '') as String,
      paymentOrderId: (pg['paymentOrderId'] ?? '') as String,
      upiIntent: (pg['upiIntent'] ?? '') as String,
    );
  }
}

/// Buy Order Confirmed Receipt Model
class BuyConfirmedModel {
  final String title;
  final String subTitle;
  final String orderId;
  final String receiptNumber;
  final String paymentTransactionId;
  final String metal;
  final String metalName;
  final double grams;
  final String gramsDisplay;
  final double amount;
  final String amountDisplay;
  final double ratePerGram;
  final String rateDisplay;
  final double basePrice;
  final double gstAmount;
  final String destination;
  final String vaultAssurance;
  final double goldVaultBalance;
  final double silverVaultBalance;

  BuyConfirmedModel({
    required this.title,
    required this.subTitle,
    required this.orderId,
    required this.receiptNumber,
    required this.paymentTransactionId,
    required this.metal,
    required this.metalName,
    required this.grams,
    required this.gramsDisplay,
    required this.amount,
    required this.amountDisplay,
    required this.ratePerGram,
    required this.rateDisplay,
    required this.basePrice,
    required this.gstAmount,
    required this.destination,
    required this.vaultAssurance,
    required this.goldVaultBalance,
    required this.silverVaultBalance,
  });

  factory BuyConfirmedModel.fromJson(Map<String, dynamic> json) {
    final vb = json['vaultBalances'] as Map<String, dynamic>? ?? {};
    return BuyConfirmedModel(
      title: (json['title'] ?? 'Purchase Successful!') as String,
      subTitle: (json['subTitle'] ?? 'Added to your physical secure vault') as String,
      orderId: (json['orderId'] ?? '') as String,
      receiptNumber: (json['receiptNumber'] ?? '') as String,
      paymentTransactionId: (json['paymentTransactionId'] ?? '') as String,
      metal: (json['metal'] ?? 'gold') as String,
      metalName: (json['metalName'] ?? '24K Gold') as String,
      grams: (json['grams'] as num?)?.toDouble() ?? 0.0,
      gramsDisplay: (json['gramsDisplay'] ?? '') as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      amountDisplay: (json['amountDisplay'] ?? '') as String,
      ratePerGram: (json['ratePerGram'] as num?)?.toDouble() ?? 0.0,
      rateDisplay: (json['rateDisplay'] ?? '') as String,
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
      gstAmount: (json['gstAmount'] as num?)?.toDouble() ?? 0.0,
      destination: (json['destination'] ?? "Brink's Secure Physical Vault") as String,
      vaultAssurance: (json['vaultAssurance'] ?? "100% Insured • 24K Hallmark • Brink's Vaulted") as String,
      goldVaultBalance: (vb['goldGrams'] as num?)?.toDouble() ?? 0.0,
      silverVaultBalance: (vb['silverGrams'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// Sell Order Calculation Result Model
class SellCalculationModel {
  final String metal;
  final double sellingRatePerGram;
  final double gramsToSell;
  final double availableGramsInVault;
  final double availableTotalValue;
  final double processingFees;
  final String feeDescription;
  final double netPayoutAmount;
  final String? destinationBankName;
  final String? maskedAccountNumber;
  final String? ifscCode;

  SellCalculationModel({
    required this.metal,
    required this.sellingRatePerGram,
    required this.gramsToSell,
    required this.availableGramsInVault,
    required this.availableTotalValue,
    required this.processingFees,
    required this.feeDescription,
    required this.netPayoutAmount,
    this.destinationBankName,
    this.maskedAccountNumber,
    this.ifscCode,
  });

  factory SellCalculationModel.fromJson(Map<String, dynamic> json) {
    final bank = json['destinationBank'] as Map<String, dynamic>? ?? {};
    return SellCalculationModel(
      metal: (json['metal'] ?? 'gold') as String,
      sellingRatePerGram: (json['sellingRatePerGram'] as num?)?.toDouble() ?? 0.0,
      gramsToSell: (json['gramsToSell'] as num?)?.toDouble() ?? 0.0,
      availableGramsInVault: (json['availableGramsInVault'] as num?)?.toDouble() ?? 0.0,
      availableTotalValue: (json['availableTotalValue'] as num?)?.toDouble() ?? 0.0,
      processingFees: (json['processingFees'] as num?)?.toDouble() ?? 0.0,
      feeDescription: (json['feeDescription'] ?? 'Zero Fee IMPS Instant Bank Payout') as String,
      netPayoutAmount: (json['netPayoutAmount'] as num?)?.toDouble() ?? 0.0,
      destinationBankName: bank['bankName'] as String?,
      maskedAccountNumber: bank['maskedAccountNumber'] as String?,
      ifscCode: bank['ifscCode'] as String?,
    );
  }
}

/// Sell Order Initiated Model
class SellInitiatedModel {
  final String title;
  final String subTitle;
  final String orderId;
  final String receiptNumber;
  final String metal;
  final String metalName;
  final double gramsWithdrawn;
  final String gramsDisplay;
  final double sellingRatePerGram;
  final String rateDisplay;
  final double payoutAmount;
  final String payoutDisplay;
  final String destinationAccount;
  final String processingTime;
  final double remainingGoldGrams;
  final double remainingSilverGrams;

  SellInitiatedModel({
    required this.title,
    required this.subTitle,
    required this.orderId,
    required this.receiptNumber,
    required this.metal,
    required this.metalName,
    required this.gramsWithdrawn,
    required this.gramsDisplay,
    required this.sellingRatePerGram,
    required this.rateDisplay,
    required this.payoutAmount,
    required this.payoutDisplay,
    required this.destinationAccount,
    required this.processingTime,
    required this.remainingGoldGrams,
    required this.remainingSilverGrams,
  });

  factory SellInitiatedModel.fromJson(Map<String, dynamic> json) {
    final rv = json['remainingVaultBalance'] as Map<String, dynamic>? ?? {};
    return SellInitiatedModel(
      title: (json['title'] ?? 'Withdrawal Initiated!') as String,
      subTitle: (json['subTitle'] ?? 'Amount will reflect in your account within 15 mins') as String,
      orderId: (json['orderId'] ?? '') as String,
      receiptNumber: (json['receiptNumber'] ?? '') as String,
      metal: (json['metal'] ?? 'gold') as String,
      metalName: (json['metalName'] ?? '24K Gold') as String,
      gramsWithdrawn: (json['gramsWithdrawn'] as num?)?.toDouble() ?? 0.0,
      gramsDisplay: (json['gramsDisplay'] ?? '') as String,
      sellingRatePerGram: (json['sellingRatePerGram'] as num?)?.toDouble() ?? 0.0,
      rateDisplay: (json['rateDisplay'] ?? '') as String,
      payoutAmount: (json['payoutAmount'] as num?)?.toDouble() ?? 0.0,
      payoutDisplay: (json['payoutDisplay'] ?? '') as String,
      destinationAccount: (json['destinationAccount'] ?? '') as String,
      processingTime: (json['processingTime'] ?? 'Instant IMPS (under 15 mins)') as String,
      remainingGoldGrams: (rv['goldGrams'] as num?)?.toDouble() ?? 0.0,
      remainingSilverGrams: (rv['silverGrams'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

