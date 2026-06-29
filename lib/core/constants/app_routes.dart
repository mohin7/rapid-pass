/// Named route paths used by GoRouter.
abstract final class AppRoutes {
  // ── Shell (bottom nav tabs) ───────────────────────────────────────────────
  static const String shell = '/';
  static const String home = '/home';
  static const String history = '/history';
  static const String fareCalculator = '/fare-calculator';
  static const String metroMap = '/metro-map';
  static const String settings = '/settings';

  // ── NFC Scan ──────────────────────────────────────────────────────────────
  static const String nfcScan = '/nfc-scan';

  // ── Detail screens ────────────────────────────────────────────────────────
  static const String tripDetail = '/history/trip/:id';
  static const String cardDetail = '/card-detail';
  static const String stationDetail = '/station/:code';
  static const String statistics = '/statistics';
  static const String rechargeHistory = '/recharge-history';
  static const String search = '/search';

  // ── Settings sub-screens ──────────────────────────────────────────────────
  static const String about = '/settings/about';
  static const String help = '/settings/help';
  static const String privacyPolicy = '/settings/privacy';
}
