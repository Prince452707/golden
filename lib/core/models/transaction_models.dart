/// Transaction Item Model
class TransactionItemModel {
  final String orderId;
  final String type;
  final String metal;
  final String title;
  final double grams;
  final double amount;
  final double ratePerGram;
  final bool isCredit;
  final String status;
  final String createdAt;

  TransactionItemModel({
    required this.orderId,
    required this.type,
    this.metal = 'Gold',
    required this.title,
    required this.grams,
    required this.amount,
    required this.ratePerGram,
    required this.isCredit,
    required this.status,
    required this.createdAt,
  });

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] ?? '') as String;
    return TransactionItemModel(
      orderId: (json['orderId'] ?? '') as String,
      type: (json['type'] ?? 'buy') as String,
      metal: (json['metal'] ?? (title.toLowerCase().contains('silver') ? 'Silver' : 'Gold')) as String,
      title: title,
      grams: (json['grams'] as num?)?.toDouble() ?? 0.0,
      amount: ((json['amount'] ?? json['totalAmount']) as num?)?.toDouble() ?? 0.0,
      ratePerGram: (json['ratePerGram'] as num?)?.toDouble() ?? 0.0,
      isCredit: json['isCredit'] as bool? ?? false,
      status: (json['status'] ?? 'completed') as String,
      createdAt: (json['createdAt'] ?? '') as String,
    );
  }
}

/// Pagination Model
class PaginationModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }
}

/// Transactions Ledger Envelope
class TransactionsLedgerData {
  final List<TransactionItemModel> transactions;
  final PaginationModel pagination;

  TransactionsLedgerData({
    required this.transactions,
    required this.pagination,
  });

  List<TransactionItemModel> get items => transactions;

  factory TransactionsLedgerData.fromJson(Map<String, dynamic> json) {
    final rawList = json['transactions'] as List<dynamic>? ?? [];
    return TransactionsLedgerData(
      transactions: rawList.map((t) => TransactionItemModel.fromJson(t as Map<String, dynamic>)).toList(),
      pagination: PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>? ?? {}),
    );
  }
}

/// Digital Tax Invoice Model
class DigitalInvoiceModel {
  final String invoiceNumber;
  final String invoiceDate;
  final String sellerCompanyName;
  final String sellerGstin;
  final String buyerName;
  final String buyerPhone;
  final String buyerPan;
  final String orderId;
  final String metalDescription;
  final String hsnCode;
  final double quantityGrams;
  final double ratePerGram;
  final double taxableBaseAmount;
  final double cgstAmount;
  final double sgstAmount;
  final double totalPayableAmount;

  DigitalInvoiceModel({
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.sellerCompanyName,
    required this.sellerGstin,
    required this.buyerName,
    required this.buyerPhone,
    required this.buyerPan,
    required this.orderId,
    required this.metalDescription,
    required this.hsnCode,
    required this.quantityGrams,
    required this.ratePerGram,
    required this.taxableBaseAmount,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.totalPayableAmount,
  });

  factory DigitalInvoiceModel.fromJson(Map<String, dynamic> json) {
    final seller = json['sellerDetails'] as Map<String, dynamic>? ?? {};
    final buyer = json['buyerDetails'] as Map<String, dynamic>? ?? {};
    final item = json['itemDetails'] as Map<String, dynamic>? ?? {};

    return DigitalInvoiceModel(
      invoiceNumber: (json['invoiceNumber'] ?? '') as String,
      invoiceDate: (json['invoiceDate'] ?? '') as String,
      sellerCompanyName: (seller['companyName'] ?? 'Golden Bullion Digital Vaults Pvt. Ltd.') as String,
      sellerGstin: (seller['gstin'] ?? '07AAAAA0000A1Z5') as String,
      buyerName: (buyer['name'] ?? '') as String,
      buyerPhone: (buyer['phone'] ?? '') as String,
      buyerPan: (buyer['pan'] ?? '') as String,
      orderId: (item['orderId'] ?? '') as String,
      metalDescription: (item['metal'] ?? '24 Karat 99.9% Pure Hallmarked Digital Gold') as String,
      hsnCode: (item['hsnCode'] ?? '7108') as String,
      quantityGrams: (item['quantityGrams'] as num?)?.toDouble() ?? 0.0,
      ratePerGram: (item['ratePerGram'] as num?)?.toDouble() ?? 0.0,
      taxableBaseAmount: (item['taxableBaseAmount'] as num?)?.toDouble() ?? 0.0,
      cgstAmount: (item['cgstAmount'] as num?)?.toDouble() ?? 0.0,
      sgstAmount: (item['sgstAmount'] as num?)?.toDouble() ?? 0.0,
      totalPayableAmount: (item['totalPayableAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

