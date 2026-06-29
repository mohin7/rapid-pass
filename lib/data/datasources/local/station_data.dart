import '../../../domain/entities/station.dart';

/// Complete MRT Line 6 station data with DMTCL-published information.
/// Source: Dhaka Mass Transit Company Limited (DMTCL) official data.
abstract final class StationData {
  static const List<MetroStation> mrt6Stations = [
    MetroStation(
      id: 'mrt6_01',
      code: 'UN',
      nameEn: 'Uttara North',
      nameBn: 'উত্তরা উত্তর',
      line: MetroLine.mrt6,
      sequenceNumber: 1,
      distanceFromStart: 0.0,
      latitude: 23.8728,
      longitude: 90.3987,
    ),
    MetroStation(
      id: 'mrt6_02',
      code: 'UC',
      nameEn: 'Uttara Centre',
      nameBn: 'উত্তরা সেন্টার',
      line: MetroLine.mrt6,
      sequenceNumber: 2,
      distanceFromStart: 1.42,
      latitude: 23.8628,
      longitude: 90.3990,
    ),
    MetroStation(
      id: 'mrt6_03',
      code: 'US',
      nameEn: 'Uttara South',
      nameBn: 'উত্তরা দক্ষিণ',
      line: MetroLine.mrt6,
      sequenceNumber: 3,
      distanceFromStart: 2.85,
      latitude: 23.8528,
      longitude: 90.3993,
    ),
    MetroStation(
      id: 'mrt6_04',
      code: 'PL',
      nameEn: 'Pallabi',
      nameBn: 'পল্লবী',
      line: MetroLine.mrt6,
      sequenceNumber: 4,
      distanceFromStart: 4.70,
      latitude: 23.8350,
      longitude: 90.3785,
    ),
    MetroStation(
      id: 'mrt6_05',
      code: 'M11',
      nameEn: 'Mirpur 11',
      nameBn: 'মিরপুর ১১',
      line: MetroLine.mrt6,
      sequenceNumber: 5,
      distanceFromStart: 5.91,
      latitude: 23.8220,
      longitude: 90.3720,
    ),
    MetroStation(
      id: 'mrt6_06',
      code: 'M10',
      nameEn: 'Mirpur 10',
      nameBn: 'মিরপুর ১০',
      line: MetroLine.mrt6,
      sequenceNumber: 6,
      distanceFromStart: 7.00,
      latitude: 23.8136,
      longitude: 90.3668,
      isInterchange: true,
      interchangeLines: [MetroLine.mrt5North],
    ),
    MetroStation(
      id: 'mrt6_07',
      code: 'KZ',
      nameEn: 'Kazipara',
      nameBn: 'কাজীপাড়া',
      line: MetroLine.mrt6,
      sequenceNumber: 7,
      distanceFromStart: 7.85,
      latitude: 23.8048,
      longitude: 90.3650,
    ),
    MetroStation(
      id: 'mrt6_08',
      code: 'SW',
      nameEn: 'Shewrapara',
      nameBn: 'শেওড়াপাড়া',
      line: MetroLine.mrt6,
      sequenceNumber: 8,
      distanceFromStart: 9.00,
      latitude: 23.7948,
      longitude: 90.3672,
    ),
    MetroStation(
      id: 'mrt6_09',
      code: 'AG',
      nameEn: 'Agargaon',
      nameBn: 'আগারগাঁও',
      line: MetroLine.mrt6,
      sequenceNumber: 9,
      distanceFromStart: 10.54,
      latitude: 23.7782,
      longitude: 90.3710,
    ),
    MetroStation(
      id: 'mrt6_10',
      code: 'BS',
      nameEn: 'Bijoy Sarani',
      nameBn: 'বিজয় সরণি',
      line: MetroLine.mrt6,
      sequenceNumber: 10,
      distanceFromStart: 12.10,
      latitude: 23.7625,
      longitude: 90.3810,
    ),
    MetroStation(
      id: 'mrt6_11',
      code: 'FG',
      nameEn: 'Farmgate',
      nameBn: 'ফার্মগেট',
      line: MetroLine.mrt6,
      sequenceNumber: 11,
      distanceFromStart: 13.25,
      latitude: 23.7539,
      longitude: 90.3893,
    ),
    MetroStation(
      id: 'mrt6_12',
      code: 'KB',
      nameEn: 'Kawran Bazar',
      nameBn: 'কারওয়ান বাজার',
      line: MetroLine.mrt6,
      sequenceNumber: 12,
      distanceFromStart: 14.35,
      latitude: 23.7503,
      longitude: 90.3931,
    ),
    MetroStation(
      id: 'mrt6_13',
      code: 'SH',
      nameEn: 'Shahbag',
      nameBn: 'শাহবাগ',
      line: MetroLine.mrt6,
      sequenceNumber: 13,
      distanceFromStart: 15.68,
      latitude: 23.7386,
      longitude: 90.3950,
    ),
    MetroStation(
      id: 'mrt6_14',
      code: 'DU',
      nameEn: 'Dhaka University',
      nameBn: 'ঢাকা বিশ্ববিদ্যালয়',
      line: MetroLine.mrt6,
      sequenceNumber: 14,
      distanceFromStart: 16.65,
      latitude: 23.7300,
      longitude: 90.3934,
    ),
    MetroStation(
      id: 'mrt6_15',
      code: 'BDS',
      nameEn: 'Bangladesh Secretariat',
      nameBn: 'বাংলাদেশ সচিবালয়',
      line: MetroLine.mrt6,
      sequenceNumber: 15,
      distanceFromStart: 17.68,
      latitude: 23.7252,
      longitude: 90.4093,
    ),
    MetroStation(
      id: 'mrt6_16',
      code: 'MT',
      nameEn: 'Motijheel',
      nameBn: 'মতিঝিল',
      line: MetroLine.mrt6,
      sequenceNumber: 16,
      distanceFromStart: 19.87,
      latitude: 23.7277,
      longitude: 90.4186,
    ),
    MetroStation(
      id: 'mrt6_17',
      code: 'KP',
      nameEn: 'Kamalapur',
      nameBn: 'কমলাপুর',
      line: MetroLine.mrt6,
      sequenceNumber: 17,
      distanceFromStart: 21.26,
      latitude: 23.7333,
      longitude: 90.4282,
    ),
  ];

  /// All stations across all lines
  static List<MetroStation> get allStations => [...mrt6Stations];

  /// Get station by code
  static MetroStation? findByCode(String code) {
    try {
      return allStations.firstWhere((s) => s.code == code);
    } catch (_) {
      return null;
    }
  }

  /// Get station by name (case-insensitive search)
  static List<MetroStation> searchByName(String query) {
    final q = query.toLowerCase();
    return allStations
        .where((s) =>
            s.nameEn.toLowerCase().contains(q) || s.nameBn.contains(query))
        .toList();
  }

  /// Calculate distance between two stations on the same line
  static double distanceBetween(MetroStation from, MetroStation to) {
    return (from.distanceFromStart - to.distanceFromStart).abs();
  }

  /// Calculate fare based on DMTCL published rate table
  static double calculateFare(MetroStation from, MetroStation to) {
    final distance = distanceBetween(from, to);
    if (distance == 0) return 0;
    if (distance <= 2) return 20.0;
    if (distance <= 5) return 30.0;
    if (distance <= 8) return 40.0;
    if (distance <= 11) return 60.0;
    if (distance <= 14) return 80.0;
    if (distance <= 17) return 90.0;
    return 100.0;
  }

  /// Get all stations between two stations (inclusive)
  static List<MetroStation> getRoute(MetroStation from, MetroStation to) {
    final fromIdx = from.sequenceNumber;
    final toIdx = to.sequenceNumber;
    final start = fromIdx < toIdx ? fromIdx : toIdx;
    final end = fromIdx < toIdx ? toIdx : fromIdx;

    final route = allStations
        .where((s) =>
            s.line == from.line &&
            s.sequenceNumber >= start &&
            s.sequenceNumber <= end)
        .toList();

    if (fromIdx > toIdx) {
      return route.reversed.toList();
    }
    return route;
  }

  /// Estimated travel time in minutes (approx 90 sec per station + 3 min overhead)
  static int estimatedMinutes(MetroStation from, MetroStation to) {
    final stationsCount =
        (from.sequenceNumber - to.sequenceNumber).abs();
    return (stationsCount * 2) + 3;
  }
}
