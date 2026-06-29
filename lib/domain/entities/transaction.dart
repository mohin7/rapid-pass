/// Domain entity representing a single card transaction.
/// Covers both journeys and recharge events.
class CardTransaction {
  const CardTransaction({
    required this.id,
    required this.type,
    required this.entryStation,
    required this.exitStation,
    required this.entryTime,
    required this.exitTime,
    required this.fare,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.distance,
    required this.duration,
    this.rechargeAmount,
  });

  final String id;
  final TransactionType type;
  final String entryStation;
  final String? exitStation;
  final DateTime entryTime;
  final DateTime? exitTime;
  final double fare;
  final double balanceBefore;
  final double balanceAfter;

  /// Distance in kilometers (0 for recharges)
  final double distance;

  /// Duration in minutes (0 for recharges)
  final int duration;

  /// Only set for recharge transactions
  final double? rechargeAmount;

  bool get isJourney => type == TransactionType.journey;
  bool get isRecharge => type == TransactionType.recharge;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CardTransaction && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum TransactionType {
  journey,
  recharge,
}
