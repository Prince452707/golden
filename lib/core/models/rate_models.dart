/// Live Rate Model for individual precious metal
class MetalRateModel {
  final String metal;
  final String purity;
  final double buyPricePerGram;
  final double baseBuyPricePerGram;
  final double gstPercentage;
  final double gstAmountPerGram;
  final double sellPricePerGram;
  final double spreadPerGram;
  final double changeTodayPercentage;
  final double changeValue;
  final String marketStatus;
  final String unit;
  final String currency;

  MetalRateModel({
    required this.metal,
    required this.purity,
    required this.buyPricePerGram,
    required this.baseBuyPricePerGram,
    required this.gstPercentage,
    required this.gstAmountPerGram,
    required this.sellPricePerGram,
    required this.spreadPerGram,
    required this.changeTodayPercentage,
    required this.changeValue,
    required this.marketStatus,
    this.unit = 'gram',
    this.currency = 'INR',
  });

  double get buyRate => buyPricePerGram;
  double get sellRate => sellPricePerGram;

  factory MetalRateModel.fromJson(Map<String, dynamic> json) {
    return MetalRateModel(
      metal: (json['metal'] ?? 'gold') as String,
      purity: (json['purity'] ?? '') as String,
      buyPricePerGram: (json['buyPricePerGram'] as num?)?.toDouble() ?? 0.0,
      baseBuyPricePerGram: (json['baseBuyPricePerGram'] as num?)?.toDouble() ?? 0.0,
      gstPercentage: (json['gstPercentage'] as num?)?.toDouble() ?? 3.0,
      gstAmountPerGram: (json['gstAmountPerGram'] as num?)?.toDouble() ?? 0.0,
      sellPricePerGram: (json['sellPricePerGram'] as num?)?.toDouble() ?? 0.0,
      spreadPerGram: (json['spreadPerGram'] as num?)?.toDouble() ?? 0.0,
      changeTodayPercentage: (json['changeTodayPercentage'] as num?)?.toDouble() ?? 0.0,
      changeValue: (json['changeValue'] as num?)?.toDouble() ?? 0.0,
      marketStatus: (json['marketStatus'] ?? 'open') as String,
      unit: (json['unit'] ?? 'gram') as String,
      currency: (json['currency'] ?? 'INR') as String,
    );
  }
}

/// Aggregated Live Rates response
class LiveRatesData {
  final MetalRateModel gold;
  final MetalRateModel silver;
  final String taxNotice;

  LiveRatesData({
    required this.gold,
    required this.silver,
    required this.taxNotice,
  });

  factory LiveRatesData.fromJson(Map<String, dynamic> json) {
    return LiveRatesData(
      gold: MetalRateModel.fromJson(json['gold'] as Map<String, dynamic>? ?? {}),
      silver: MetalRateModel.fromJson(json['silver'] as Map<String, dynamic>? ?? {}),
      taxNotice: (json['taxNotice'] ?? '') as String,
    );
  }
}

/// 5-Minute Price Lock Quote Model
class LockQuoteModel {
  final String quoteId;
  final String metal;
  final double ratePerGram;
  final double gstPercentage;
  final String lockedAt;
  final String expiresAt;
  final int durationSeconds;

  LockQuoteModel({
    required this.quoteId,
    required this.metal,
    required this.ratePerGram,
    required this.gstPercentage,
    required this.lockedAt,
    required this.expiresAt,
    required this.durationSeconds,
  });

  factory LockQuoteModel.fromJson(Map<String, dynamic> json) {
    return LockQuoteModel(
      quoteId: (json['quoteId'] ?? '') as String,
      metal: (json['metal'] ?? 'gold') as String,
      ratePerGram: (json['ratePerGram'] as num?)?.toDouble() ?? 0.0,
      gstPercentage: (json['gstPercentage'] as num?)?.toDouble() ?? 3.0,
      lockedAt: (json['lockedAt'] ?? '') as String,
      expiresAt: (json['expiresAt'] ?? '') as String,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 300,
    );
  }
}

/// Price Point on Chart
class PriceHistoryPoint {
  final String timestamp;
  final double price;

  PriceHistoryPoint({required this.timestamp, required this.price});

  factory PriceHistoryPoint.fromJson(Map<String, dynamic> json) {
    return PriceHistoryPoint(
      timestamp: (json['timestamp'] ?? '') as String,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// Historical Price Trajectory Model
class PriceHistoryModel {
  final String metal;
  final String timeframe;
  final double highPrice;
  final double lowPrice;
  final double avgPrice;
  final double changePercentage;
  final List<PriceHistoryPoint> points;

  PriceHistoryModel({
    required this.metal,
    required this.timeframe,
    required this.highPrice,
    required this.lowPrice,
    required this.avgPrice,
    required this.changePercentage,
    required this.points,
  });

  List<PriceHistoryPoint> get trajectory => points;

  factory PriceHistoryModel.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['points'] as List<dynamic>? ?? [];
    return PriceHistoryModel(
      metal: (json['metal'] ?? 'gold') as String,
      timeframe: (json['timeframe'] ?? '6M') as String,
      highPrice: (json['highPrice'] as num?)?.toDouble() ?? 0.0,
      lowPrice: (json['lowPrice'] as num?)?.toDouble() ?? 0.0,
      avgPrice: (json['avgPrice'] as num?)?.toDouble() ?? 0.0,
      changePercentage: (json['changePercentage'] as num?)?.toDouble() ?? 0.0,
      points: rawPoints.map((p) => PriceHistoryPoint.fromJson(p as Map<String, dynamic>)).toList(),
    );
  }
}

