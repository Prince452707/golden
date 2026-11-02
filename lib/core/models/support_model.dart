/// Support Ticket Model
class SupportTicketModel {
  final String id;
  final String subject;
  final String category;
  final String status;
  final String advisorAssigned;

  SupportTicketModel({
    required this.id,
    required this.subject,
    required this.category,
    required this.status,
    required this.advisorAssigned,
  });

  String get ticketId => id;
  String get assignedAdvisor => advisorAssigned;

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: (json['id'] ?? json['ticketId'] ?? json['_id'] ?? '') as String,
      subject: (json['subject'] ?? '') as String,
      category: (json['category'] ?? 'Vault & Delivery') as String,
      status: (json['status'] ?? 'open') as String,
      advisorAssigned: (json['advisorAssigned'] ?? json['assignedAdvisor'] ?? '24/7 Dedicated Gold Advisor') as String,
    );
  }
}

/// Trust Badge Model
class TrustBadgeModel {
  final String title;
  final String description;

  TrustBadgeModel({required this.title, required this.description});

  String get subtitle => description;

  factory TrustBadgeModel.fromJson(Map<String, dynamic> json) {
    return TrustBadgeModel(
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? json['subtitle'] ?? '') as String,
    );
  }
}

/// FAQ Item Model
class FaqItemModel {
  final String question;
  final String answer;

  FaqItemModel({required this.question, required this.answer});

  factory FaqItemModel.fromJson(Map<String, dynamic> json) {
    return FaqItemModel(
      question: (json['question'] ?? '') as String,
      answer: (json['answer'] ?? '') as String,
    );
  }
}

/// Trust Pillars and FAQs Envelope
class TrustFaqsDataModel {
  final List<FaqItemModel> faqs;
  final List<TrustBadgeModel> trustBadges;
  final String advisorNotice;

  TrustFaqsDataModel({
    required this.faqs,
    required this.trustBadges,
    required this.advisorNotice,
  });

  factory TrustFaqsDataModel.fromJson(Map<String, dynamic> json) {
    final rawFaqs = json['faqs'] as List<dynamic>? ?? [];
    final rawBadges = json['trustBadges'] as List<dynamic>? ?? [];

    return TrustFaqsDataModel(
      faqs: rawFaqs.map((f) => FaqItemModel.fromJson(f as Map<String, dynamic>)).toList(),
      trustBadges: rawBadges.map((b) => TrustBadgeModel.fromJson(b as Map<String, dynamic>)).toList(),
      advisorNotice: (json['advisorNotice'] ?? '💬 Support: 24/7 Dedicated Gold Advisor online') as String,
    );
  }
}

typedef TrustFaqsModel = TrustFaqsDataModel;

