/// Golden User Profile Model
class UserModel {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String countryCode;
  final String email;
  final String avatarInitials;
  final String kycStatus;
  final String? panNumber;
  final String? aadhaarNumber;
  final double goldVaultBalanceGrams;
  final double silverVaultBalanceGrams;
  final double gullakCashBalance;
  final double totalGoldInvestedAmount;
  final double totalSilverInvestedAmount;
  final String referralCode;
  final bool isNewUser;
  final String? state;
  final String? city;

  UserModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.countryCode,
    this.email = '',
    required this.avatarInitials,
    required this.kycStatus,
    this.panNumber,
    this.aadhaarNumber,
    required this.goldVaultBalanceGrams,
    required this.silverVaultBalanceGrams,
    required this.gullakCashBalance,
    this.totalGoldInvestedAmount = 0.0,
    this.totalSilverInvestedAmount = 0.0,
    required this.referralCode,
    this.isNewUser = false,
    this.state,
    this.city,
  });

  double get goldBalanceGrams => goldVaultBalanceGrams;
  double get silverBalanceGrams => silverVaultBalanceGrams;

  /// Checks if real user-provided profile data (such as legal name) is already available
  bool get hasProfileData {
    final cleanName = fullName.trim().toLowerCase();
    if (cleanName.isEmpty) return false;
    if (cleanName == 'bullion investor') return false;
    if (cleanName == 'golden member') return false;
    return true;
  }

  /// Checks if user profile is already filled
  bool get isProfileComplete => hasProfileData;

 
  /// Whether the user needs to fill their profile details:
  /// 1. If backend explicitly marked user as a new user registration (isNewUser): ALWAYS prompt (true)
  /// 2. If the user does not have real custom profile data (blank or default name): ALWAYS prompt (true)
  /// 3. Otherwise: existing user with real profile data -> do not prompt (false)
  bool get needsFirstTimeProfileSetup {
    if (isNewUser) return true;
    if (!hasProfileData) return true;
    return false;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawFullName = (json['fullName'] ?? '') as String;
    return UserModel(
      id: (json['id'] ?? json['_id'] ?? '') as String,
      fullName: rawFullName.isNotEmpty ? rawFullName : 'Bullion Investor',
      phoneNumber: (json['phoneNumber'] ?? '') as String,
      countryCode: (json['countryCode'] ?? '+91') as String,
      email: (json['email'] ?? '') as String,
      avatarInitials: (json['avatarInitials'] ?? '') as String,
      kycStatus: (json['kycStatus'] ?? 'unverified') as String,
      panNumber: json['panNumber'] as String?,
      aadhaarNumber: json['aadhaarNumber'] as String?,
      goldVaultBalanceGrams: (json['goldVaultBalanceGrams'] as num?)?.toDouble() ?? 0.0,
      silverVaultBalanceGrams: (json['silverVaultBalanceGrams'] as num?)?.toDouble() ?? 0.0,
      gullakCashBalance: (json['gullakCashBalance'] as num?)?.toDouble() ?? 0.0,
      totalGoldInvestedAmount: (json['totalGoldInvestedAmount'] as num?)?.toDouble() ?? 0.0,
      totalSilverInvestedAmount: (json['totalSilverInvestedAmount'] as num?)?.toDouble() ?? 0.0,
      referralCode: (json['referralCode'] ?? 'GOLD777999') as String,
      isNewUser: json['isNewUser'] as bool? ?? false,
      state: json['state'] as String?,
      city: json['city'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'email': email,
      'avatarInitials': avatarInitials,
      'kycStatus': kycStatus,
      'panNumber': panNumber,
      'aadhaarNumber': aadhaarNumber,
      'goldVaultBalanceGrams': goldVaultBalanceGrams,
      'silverVaultBalanceGrams': silverVaultBalanceGrams,
      'gullakCashBalance': gullakCashBalance,
      'totalGoldInvestedAmount': totalGoldInvestedAmount,
      'totalSilverInvestedAmount': totalSilverInvestedAmount,
      'referralCode': referralCode,
      'isNewUser': isNewUser,
      'state': state,
      'city': city,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? countryCode,
    String? email,
    String? avatarInitials,
    String? kycStatus,
    String? panNumber,
    String? aadhaarNumber,
    double? goldVaultBalanceGrams,
    double? silverVaultBalanceGrams,
    double? gullakCashBalance,
    double? totalGoldInvestedAmount,
    double? totalSilverInvestedAmount,
    String? referralCode,
    bool? isNewUser,
    String? state,
    String? city,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      email: email ?? this.email,
      avatarInitials: avatarInitials ?? this.avatarInitials,
      kycStatus: kycStatus ?? this.kycStatus,
      panNumber: panNumber ?? this.panNumber,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      goldVaultBalanceGrams: goldVaultBalanceGrams ?? this.goldVaultBalanceGrams,
      silverVaultBalanceGrams: silverVaultBalanceGrams ?? this.silverVaultBalanceGrams,
      gullakCashBalance: gullakCashBalance ?? this.gullakCashBalance,
      totalGoldInvestedAmount: totalGoldInvestedAmount ?? this.totalGoldInvestedAmount,
      totalSilverInvestedAmount: totalSilverInvestedAmount ?? this.totalSilverInvestedAmount,
      referralCode: referralCode ?? this.referralCode,
      isNewUser: isNewUser ?? this.isNewUser,
      state: state ?? this.state,
      city: city ?? this.city,
    );
  }
}

