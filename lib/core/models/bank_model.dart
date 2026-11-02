/// Linked Bank Account Model
class BankAccountModel {
  final String id;
  final String bankName;
  final String maskedAccountNumber;
  final String ifscCode;
  final String accountHolderName;
  final bool isPrimary;
  final bool isVerified;

  BankAccountModel({
    required this.id,
    required this.bankName,
    required this.maskedAccountNumber,
    required this.ifscCode,
    required this.accountHolderName,
    required this.isPrimary,
    required this.isVerified,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      id: (json['id'] ?? json['_id'] ?? '') as String,
      bankName: (json['bankName'] ?? '') as String,
      maskedAccountNumber: (json['maskedAccountNumber'] ?? '') as String,
      ifscCode: (json['ifscCode'] ?? '') as String,
      accountHolderName: (json['accountHolderName'] ?? '') as String,
      isPrimary: json['isPrimary'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }
}

