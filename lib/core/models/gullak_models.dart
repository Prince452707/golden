/// Gullak Preset Catalog Item
class GullakCatalogItem {
  final String id;
  final String prefix;
  final String title;
  final String cleanImageAsset;
  final double defaultTarget;
  final String description;

  GullakCatalogItem({
    required this.id,
    required this.prefix,
    required this.title,
    required this.cleanImageAsset,
    required this.defaultTarget,
    required this.description,
  });

  factory GullakCatalogItem.fromJson(Map<String, dynamic> json) {
    return GullakCatalogItem(
      id: (json['id'] ?? '') as String,
      prefix: (json['prefix'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      cleanImageAsset: (json['cleanImageAsset'] ?? '') as String,
      defaultTarget: (json['defaultTarget'] as num?)?.toDouble() ?? 100000.0,
      description: (json['description'] ?? '') as String,
    );
  }
}

/// User's Specific Savings Goal
class GullakGoalModel {
  final String id;
  final String title;
  final String prefix;
  final String categoryId;
  final double targetAmount;
  final double savedAmount;
  final double savedGrams;
  final double progressPercentage;
  final String frequency;
  final bool autoDebitEnabled;
  final double autoDebitAmount;
  final String status;

  GullakGoalModel({
    required this.id,
    required this.title,
    this.prefix = '',
    this.categoryId = 'custom',
    required this.targetAmount,
    required this.savedAmount,
    required this.savedGrams,
    required this.progressPercentage,
    required this.frequency,
    required this.autoDebitEnabled,
    required this.autoDebitAmount,
    required this.status,
  });

  double get accumulatedGrams => savedGrams;
  String? get iconAsset => null;

  factory GullakGoalModel.fromJson(Map<String, dynamic> json) {
    return GullakGoalModel(
      id: (json['id'] ?? json['_id'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      prefix: (json['prefix'] ?? '') as String,
      categoryId: (json['categoryId'] ?? 'custom') as String,
      targetAmount: (json['targetAmount'] as num?)?.toDouble() ?? 0.0,
      savedAmount: (json['savedAmount'] as num?)?.toDouble() ?? 0.0,
      savedGrams: (json['savedGrams'] as num?)?.toDouble() ?? 0.0,
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
      frequency: (json['frequency'] ?? 'Daily') as String,
      autoDebitEnabled: json['autoDebitEnabled'] as bool? ?? false,
      autoDebitAmount: (json['autoDebitAmount'] as num?)?.toDouble() ?? 0.0,
      status: (json['status'] ?? 'active') as String,
    );
  }
}

/// Goals Summary
class GullakSummaryModel {
  final int totalGoalsCount;
  final int activeGoalsCount;
  final double totalSavedAmount;
  final double totalSavedGrams;

  GullakSummaryModel({
    required this.totalGoalsCount,
    required this.activeGoalsCount,
    required this.totalSavedAmount,
    required this.totalSavedGrams,
  });

  factory GullakSummaryModel.fromJson(Map<String, dynamic> json) {
    return GullakSummaryModel(
      totalGoalsCount: (json['totalGoalsCount'] as num?)?.toInt() ?? 0,
      activeGoalsCount: (json['activeGoalsCount'] as num?)?.toInt() ?? 0,
      totalSavedAmount: (json['totalSavedAmount'] as num?)?.toDouble() ?? 0.0,
      totalSavedGrams: (json['totalSavedGrams'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// User Goals List + Summary Envelope
class UserGoalsData {
  final List<GullakGoalModel> goals;
  final GullakSummaryModel summary;

  UserGoalsData({required this.goals, required this.summary});

  factory UserGoalsData.fromJson(Map<String, dynamic> json) {
    final rawGoals = json['goals'] as List<dynamic>? ?? [];
    return UserGoalsData(
      goals: rawGoals.map((g) => GullakGoalModel.fromJson(g as Map<String, dynamic>)).toList(),
      summary: GullakSummaryModel.fromJson(json['summary'] as Map<String, dynamic>? ?? {}),
    );
  }
}

