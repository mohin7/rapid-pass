/// Domain entity representing a Dhaka Metro station.
/// Contains all station data for MRT Line 6 and future lines.
class MetroStation {
  const MetroStation({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameBn,
    required this.line,
    required this.sequenceNumber,
    required this.distanceFromStart,
    required this.latitude,
    required this.longitude,
    this.isInterchange = false,
    this.interchangeLines = const [],
  });

  final String id;
  final String code;
  final String nameEn;
  final String nameBn;
  final MetroLine line;
  final int sequenceNumber;

  /// Distance from the first station of the line in km
  final double distanceFromStart;

  final double latitude;
  final double longitude;
  final bool isInterchange;
  final List<MetroLine> interchangeLines;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MetroStation && code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'MetroStation($code: $nameEn)';
}

enum MetroLine {
  mrt6,
  mrt5North,
  mrt1,
}

extension MetroLineX on MetroLine {
  String get displayName {
    switch (this) {
      case MetroLine.mrt6:
        return 'MRT Line 6';
      case MetroLine.mrt5North:
        return 'MRT Line 5 (North)';
      case MetroLine.mrt1:
        return 'MRT Line 1';
    }
  }

  String get colorHex {
    switch (this) {
      case MetroLine.mrt6:
        return '006A4E';
      case MetroLine.mrt5North:
        return '0066CC';
      case MetroLine.mrt1:
        return 'E67E22';
    }
  }
}

/// Represents a fare calculation result between two stations.
class FareResult {
  const FareResult({
    required this.fromStation,
    required this.toStation,
    required this.fare,
    required this.distance,
    required this.estimatedMinutes,
    required this.stationsCount,
    required this.route,
  });

  final MetroStation fromStation;
  final MetroStation toStation;
  final double fare;
  final double distance;
  final int estimatedMinutes;
  final int stationsCount;
  final List<MetroStation> route;
}

/// Travel statistics aggregate for a card.
class TravelStatistics {
  const TravelStatistics({
    required this.totalTrips,
    required this.totalSpent,
    required this.totalDistance,
    required this.averageFare,
    required this.mostVisitedStation,
    required this.weeklySpending,
    required this.monthlySpending,
    required this.lastMonthTrips,
    required this.thisMonthTrips,
    required this.longestJourney,
    required this.shortestJourney,
  });

  final int totalTrips;
  final double totalSpent;
  final double totalDistance;
  final double averageFare;
  final String mostVisitedStation;
  final double weeklySpending;
  final double monthlySpending;
  final int lastMonthTrips;
  final int thisMonthTrips;
  final double longestJourney;
  final double shortestJourney;
}
