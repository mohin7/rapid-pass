/// Domain entity representing a Dhaka Metro Rapid Pass card.
/// This is the core data model for the application.
class RapidPassCard {
  const RapidPassCard({
    required this.id,
    required this.cardNumber,
    required this.maskedNumber,
    required this.type,
    required this.status,
    required this.balance,
    required this.currency,
    required this.issueDate,
    required this.expiryDate,
    required this.lastRechargeAmount,
    required this.lastRechargeDate,
    required this.lastScanTime,
    required this.totalTrips,
    required this.totalSpent,
    this.isDemo = false,
  });

  final String id;
  final String cardNumber;
  final String maskedNumber;
  final CardType type;
  final CardStatus status;
  final double balance;
  final String currency;
  final DateTime issueDate;
  final DateTime expiryDate;
  final double lastRechargeAmount;
  final DateTime lastRechargeDate;
  final DateTime lastScanTime;
  final int totalTrips;
  final double totalSpent;

  /// True when this card data was produced by mock service.
  final bool isDemo;

  bool get isActive => status == CardStatus.active;
  bool get isExpired => DateTime.now().isAfter(expiryDate);
  bool get isLowBalance => balance < 50.0;
  bool get isCriticalBalance => balance < 20.0;

  RapidPassCard copyWith({
    String? id,
    String? cardNumber,
    String? maskedNumber,
    CardType? type,
    CardStatus? status,
    double? balance,
    String? currency,
    DateTime? issueDate,
    DateTime? expiryDate,
    double? lastRechargeAmount,
    DateTime? lastRechargeDate,
    DateTime? lastScanTime,
    int? totalTrips,
    double? totalSpent,
    bool? isDemo,
  }) {
    return RapidPassCard(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      type: type ?? this.type,
      status: status ?? this.status,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      lastRechargeAmount: lastRechargeAmount ?? this.lastRechargeAmount,
      lastRechargeDate: lastRechargeDate ?? this.lastRechargeDate,
      lastScanTime: lastScanTime ?? this.lastScanTime,
      totalTrips: totalTrips ?? this.totalTrips,
      totalSpent: totalSpent ?? this.totalSpent,
      isDemo: isDemo ?? this.isDemo,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is RapidPassCard && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum CardType {
  rapidPass,
  mrtPass,
  studentPass,
  seniorPass,
}

extension CardTypeX on CardType {
  String get displayName {
    switch (this) {
      case CardType.rapidPass:
        return 'Rapid Pass';
      case CardType.mrtPass:
        return 'MRT Pass';
      case CardType.studentPass:
        return 'Student Pass';
      case CardType.seniorPass:
        return 'Senior Citizen Pass';
    }
  }
}

enum CardStatus {
  active,
  inactive,
  blocked,
  expired,
}

extension CardStatusX on CardStatus {
  String get displayName {
    switch (this) {
      case CardStatus.active:
        return 'Active';
      case CardStatus.inactive:
        return 'Inactive';
      case CardStatus.blocked:
        return 'Blocked';
      case CardStatus.expired:
        return 'Expired';
    }
  }
}
