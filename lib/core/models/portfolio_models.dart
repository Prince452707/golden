/// Portfolio Metal Summary
class PortfolioMetalDetail {
  final double grams;
  final double liveRate;
  final double currentValue;
  final double investedAmount;
  final double gainAmount;
  final double gainPercentage;
  final double averagePricePerGram;

  PortfolioMetalDetail({
    required this.grams,
    required this.liveRate,
    required this.currentValue,
    required this.investedAmount,
    required this.gainAmount,
    required this.gainPercentage,
    required this.averagePricePerGram,
  });

  factory PortfolioMetalDetail.fromJson(Map<String, dynamic> json) {
    return PortfolioMetalDetail(
      grams: (json['grams'] as num?)?.toDouble() ?? 0.0,
      liveRate: (json['liveRate'] as num?)?.toDouble() ?? 0.0,
      currentValue: (json['currentValue'] as num?)?.toDouble() ?? 0.0,
      investedAmount: (json['investedAmount'] as num?)?.toDouble() ?? 0.0,
      gainAmount: (json['gainAmount'] as num?)?.toDouble() ?? 0.0,
      gainPercentage: (json['gainPercentage'] as num?)?.toDouble() ?? 0.0,
      averagePricePerGram: (json['averagePricePerGram'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// Lowest Price Benchmark Banner
class LowestPriceBannerModel {
  final String title;
  final String badge;
  final String subtitle;
  final double lowestRate;
  final String lowestDate;
  final String discountBonusNotice;

  LowestPriceBannerModel({
    required this.title,
    required this.badge,
    required this.subtitle,
    required this.lowestRate,
    required this.lowestDate,
    required this.discountBonusNotice,
  });

  factory LowestPriceBannerModel.fromJson(Map<String, dynamic> json) {
    return LowestPriceBannerModel(
      title: (json['title'] ?? 'Lowest Gold Price in Last 6 Months') as String,
      badge: (json['badge'] ?? 'INVEST SMARTER') as String,
      subtitle: (json['subtitle'] ?? 'Best time to buy and grow your savings.') as String,
      lowestRate: (json['lowestRate'] as num?)?.toDouble() ?? 12860.0,
      lowestDate: (json['lowestDate'] ?? '15 Aug 2026') as String,
      discountBonusNotice: (json['discountBonusNotice'] ?? 'Get Extra 5% Gold FREE') as String,
    );
  }
}

/// Aggregated Portfolio Summary Model
class PortfolioSummaryModel {
  final double totalPortfolioValue;
  final double totalInvested;
  final double totalGain;
  final double totalGainPercentage;
  final double gullakCashBalance;
  final PortfolioMetalDetail gold;
  final PortfolioMetalDetail silver;
  final LowestPriceBannerModel lowestPriceBanner;

  PortfolioSummaryModel({
    required this.totalPortfolioValue,
    required this.totalInvested,
    required this.totalGain,
    required this.totalGainPercentage,
    required this.gullakCashBalance,
    required this.gold,
    required this.silver,
    required this.lowestPriceBanner,
  });

  Map<String, PortfolioMetalDetail> get metals => {'gold': gold, 'silver': silver};

  factory PortfolioSummaryModel.fromJson(Map<String, dynamic> json) {
    return PortfolioSummaryModel(
      totalPortfolioValue: (json['totalPortfolioValue'] as num?)?.toDouble() ?? 0.0,
      totalInvested: (json['totalInvested'] as num?)?.toDouble() ?? 0.0,
      totalGain: (json['totalGain'] as num?)?.toDouble() ?? 0.0,
      totalGainPercentage: (json['totalGainPercentage'] as num?)?.toDouble() ?? 0.0,
      gullakCashBalance: (json['gullakCashBalance'] as num?)?.toDouble() ?? 0.0,
      gold: PortfolioMetalDetail.fromJson(json['gold'] as Map<String, dynamic>? ?? {}),
      silver: PortfolioMetalDetail.fromJson(json['silver'] as Map<String, dynamic>? ?? {}),
      lowestPriceBanner: LowestPriceBannerModel.fromJson(json['lowestPriceBanner'] as Map<String, dynamic>? ?? {}),
    );
  }
}

/// Goal Allocation Item in Metal Holdings
class GoalAllocationItem {
  final String title;
  final double grams;
  final double savedAmount;
  final String tag;

  GoalAllocationItem({
    required this.title,
    required this.grams,
    required this.savedAmount,
    required this.tag,
  });

  factory GoalAllocationItem.fromJson(Map<String, dynamic> json) {
    return GoalAllocationItem(
      title: (json['title'] ?? '') as String,
      grams: (json['grams'] as num?)?.toDouble() ?? 0.0,
      savedAmount: (json['savedAmount'] as num?)?.toDouble() ?? 0.0,
      tag: (json['tag'] ?? '') as String,
    );
  }
}

/// Itemized Metal Holdings Model
class MetalHoldingsModel {
  final String metal;
  final String metalTitle;
  final double grams;
  final double liveRate;
  final double currentValue;
  final double investedAmount;
  final double gainAmount;
  final double gainPercentage;
  final double allocatedGrams;
  final double freeUnallocatedGrams;
  final List<GoalAllocationItem> goalAllocations;

  MetalHoldingsModel({
    required this.metal,
    required this.metalTitle,
    required this.grams,
    required this.liveRate,
    required this.currentValue,
    required this.investedAmount,
    required this.gainAmount,
    required this.gainPercentage,
    required this.allocatedGrams,
    required this.freeUnallocatedGrams,
    required this.goalAllocations,
  });

  factory MetalHoldingsModel.fromJson(Map<String, dynamic> json) {
    final rawAllocations = json['goalAllocations'] as List<dynamic>? ?? [];
    return MetalHoldingsModel(
      metal: (json['metal'] ?? 'gold') as String,
      metalTitle: (json['metalTitle'] ?? 'Gold (24K)') as String,
      grams: (json['grams'] as num?)?.toDouble() ?? 0.0,
      liveRate: (json['liveRate'] as num?)?.toDouble() ?? 0.0,
      currentValue: (json['currentValue'] as num?)?.toDouble() ?? 0.0,
      investedAmount: (json['investedAmount'] as num?)?.toDouble() ?? 0.0,
      gainAmount: (json['gainAmount'] as num?)?.toDouble() ?? 0.0,
      gainPercentage: (json['gainPercentage'] as num?)?.toDouble() ?? 0.0,
      allocatedGrams: (json['allocatedGrams'] as num?)?.toDouble() ?? 0.0,
      freeUnallocatedGrams: (json['freeUnallocatedGrams'] as num?)?.toDouble() ?? 0.0,
      goalAllocations: rawAllocations.map((a) => GoalAllocationItem.fromJson(a as Map<String, dynamic>)).toList(),
    );
  }
}

