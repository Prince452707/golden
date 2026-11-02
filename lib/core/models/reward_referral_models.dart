/// Referral Statistics & Share Link Model
class ReferralDataModel {
  final String referralCode;
  final String shareableLink;
  final double rewardPerReferral;
  final int totalReferralsCount;
  final int successfulReferralsCount;
  final double totalEarnedAmount;
  final String campaignBannerTitle;
  final String campaignBannerSubtitle;

  ReferralDataModel({
    required this.referralCode,
    required this.shareableLink,
    required this.rewardPerReferral,
    required this.totalReferralsCount,
    required this.successfulReferralsCount,
    required this.totalEarnedAmount,
    required this.campaignBannerTitle,
    required this.campaignBannerSubtitle,
  });

  factory ReferralDataModel.fromJson(Map<String, dynamic> json) {
    final banner = json['campaignBanner'] as Map<String, dynamic>? ?? {};
    return ReferralDataModel(
      referralCode: (json['referralCode'] ?? 'GOLD777999') as String,
      shareableLink: (json['shareableLink'] ?? 'https://golden.app/join/GOLD777999') as String,
      rewardPerReferral: (json['rewardPerReferral'] as num?)?.toDouble() ?? 1000.0,
      totalReferralsCount: (json['totalReferralsCount'] as num?)?.toInt() ?? 0,
      successfulReferralsCount: (json['successfulReferralsCount'] as num?)?.toInt() ?? 0,
      totalEarnedAmount: (json['totalEarnedAmount'] as num?)?.toDouble() ?? 0.0,
      campaignBannerTitle: (banner['title'] ?? 'Win Assured ₹1000') as String,
      campaignBannerSubtitle: (banner['subtitle'] ?? 'For every successful referral you bring in!') as String,
    );
  }
}

/// Reward Item Model (Scratch card / Gold bonus)
class RewardItemModel {
  final String id;
  final String title;
  final String rewardType;
  final double amount;
  final double goldGrams;
  final bool isClaimed;

  RewardItemModel({
    required this.id,
    required this.title,
    required this.rewardType,
    required this.amount,
    required this.goldGrams,
    required this.isClaimed,
  });

  factory RewardItemModel.fromJson(Map<String, dynamic> json) {
    return RewardItemModel(
      id: (json['id'] ?? json['_id'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      rewardType: (json['rewardType'] ?? 'scratch_card') as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      goldGrams: (json['goldGrams'] as num?)?.toDouble() ?? 0.0,
      isClaimed: json['isClaimed'] as bool? ?? false,
    );
  }
}

/// Rewards List Envelope
class RewardsEnvelopeModel {
  final List<RewardItemModel> rewards;
  final int activeScratchCardsCount;
  final String giftBoxNotice;

  RewardsEnvelopeModel({
    required this.rewards,
    required this.activeScratchCardsCount,
    required this.giftBoxNotice,
  });

  factory RewardsEnvelopeModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['rewards'] as List<dynamic>? ?? [];
    return RewardsEnvelopeModel(
      rewards: rawList.map((r) => RewardItemModel.fromJson(r as Map<String, dynamic>)).toList(),
      activeScratchCardsCount: (json['activeScratchCardsCount'] as num?)?.toInt() ?? 0,
      giftBoxNotice: (json['giftBoxNotice'] ?? '🎁 Rewards & Gifts: Scratch cards active!') as String,
    );
  }
}

