/// Application-wide constants for Rapid Pass BD.
abstract final class AppConstants {
  // ── App Info ──────────────────────────────────────────────────────────────
  static const String appName = 'Rapid Pass BD';
  static const String appTagline = 'Dhaka Metro Rapid Pass';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // ── Demo Mode ─────────────────────────────────────────────────────────────
  /// When true, NFC reads use mock data. Always true until real keys available.
  static const bool isDemoMode = true;

  // ── NFC ───────────────────────────────────────────────────────────────────
  static const int nfcTimeoutSeconds = 30;
  static const int nfcPollingIntervalMs = 500;

  // ── Balance Thresholds ────────────────────────────────────────────────────
  /// Below this balance (BDT), show low balance warning
  static const double lowBalanceThreshold = 50.0;
  /// Below this, show critical balance alert
  static const double criticalBalanceThreshold = 20.0;

  // ── Fare (MRT Line 6 — DMTCL published rates) ─────────────────────────────
  /// Base fare in BDT
  static const double minimumFare = 20.0;
  /// Per km rate in BDT
  static const double farePerKm = 5.0;
  /// Maximum single journey fare
  static const double maximumFare = 100.0;

  // ── Storage Keys ──────────────────────────────────────────────────────────
  static const String keyThemeMode = 'theme_mode';
  static const String keyLocale = 'locale';
  static const String keyBiometrics = 'biometrics_enabled';
  static const String keyLastCardId = 'last_card_id';
  static const String keySavedCardData = 'saved_card_data';

  // ── MRT Line Info ─────────────────────────────────────────────────────────
  static const String mrtLine6Name = 'MRT Line 6';
  static const String mrtLine6Color = '006A4E';
  static const int mrtLine6TotalStations = 17;
  static const double mrtLine6TotalDistance = 21.26; // km

  // ── Supported Locales ─────────────────────────────────────────────────────
  static const List<String> supportedLocaleCodes = ['en', 'bn'];

  // ── Animation Durations ───────────────────────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 250);
  static const Duration animSlow = Duration(milliseconds: 400);
  static const Duration animPage = Duration(milliseconds: 300);
  static const Duration nfcScanPulse = Duration(milliseconds: 1200);

  // ── Pagination ────────────────────────────────────────────────────────────
  static const int defaultPageSize = 20;
}
