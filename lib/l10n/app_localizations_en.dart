// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Rapid Pass BD';

  @override
  String get appTagline => 'Dhaka Metro Rapid Pass';

  @override
  String get tabHome => 'Home';

  @override
  String get tabHistory => 'History';

  @override
  String get tabFare => 'Fare';

  @override
  String get tabMap => 'Map';

  @override
  String get tabSettings => 'Settings';

  @override
  String get balance => 'Balance';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get remainingBalance => 'Remaining Balance';

  @override
  String get lowBalance => 'Low Balance';

  @override
  String get criticalBalance => 'Balance Critical';

  @override
  String get scanCard => 'Scan Card';

  @override
  String get scanning => 'Scanning...';

  @override
  String get holdCardNear =>
      'Hold your Rapid Pass card near the top of your phone';

  @override
  String get scanSuccess => 'Card Read Successfully';

  @override
  String get scanFailed => 'Scan Failed';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get demoMode => 'Demo Mode';

  @override
  String get demoModeDescription =>
      'Using demonstration data. Scan a real card for live data.';

  @override
  String get nfcUnavailable => 'NFC Not Available';

  @override
  String get nfcDisabled => 'NFC is Disabled';

  @override
  String get nfcUnsupportedCard => 'Unsupported Card';

  @override
  String get nfcReadFailure => 'Could Not Read Card';

  @override
  String get nfcPermissionDenied => 'NFC Permission Denied';

  @override
  String get nfcTimeout => 'Scan Timed Out';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get cardNumber => 'Card Number';

  @override
  String get cardType => 'Card Type';

  @override
  String get cardStatus => 'Card Status';

  @override
  String get issueDate => 'Issue Date';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get lastRecharge => 'Last Recharge';

  @override
  String get lastScan => 'Last Scan';

  @override
  String get rapidPass => 'Rapid Pass';

  @override
  String get mrtPass => 'MRT Pass';

  @override
  String get studentPass => 'Student Pass';

  @override
  String get seniorPass => 'Senior Citizen Pass';

  @override
  String get cardActive => 'Active';

  @override
  String get cardInactive => 'Inactive';

  @override
  String get cardBlocked => 'Blocked';

  @override
  String get cardExpired => 'Expired';

  @override
  String get tripHistory => 'Trip History';

  @override
  String get recentTrips => 'Recent Trips';

  @override
  String get noTrips => 'No trips yet';

  @override
  String get noTripsDescription =>
      'Scan your Rapid Pass card to see your trip history.';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get fare => 'Fare';

  @override
  String get distance => 'Distance';

  @override
  String get duration => 'Duration';

  @override
  String get departure => 'Departure';

  @override
  String get arrival => 'Arrival';

  @override
  String get journey => 'Journey';

  @override
  String get recharge => 'Recharge';

  @override
  String get rechargeHistory => 'Recharge History';

  @override
  String get rechargeAmount => 'Recharge Amount';

  @override
  String get fareCalculator => 'Fare Calculator';

  @override
  String get selectOrigin => 'Select Origin';

  @override
  String get selectDestination => 'Select Destination';

  @override
  String get calculate => 'Calculate';

  @override
  String get swapStations => 'Swap Stations';

  @override
  String get estimatedFare => 'Estimated Fare';

  @override
  String get estimatedTime => 'Estimated Time';

  @override
  String get stationsCount => 'Stations';

  @override
  String get routeSummary => 'Route Summary';

  @override
  String get selectBothStations =>
      'Please select both stations to calculate the fare.';

  @override
  String get metroMap => 'Metro Map';

  @override
  String get searchStation => 'Search station';

  @override
  String get allLines => 'All Lines';

  @override
  String get mrtLine6 => 'MRT Line 6';

  @override
  String get mrtLine5 => 'MRT Line 5';

  @override
  String get interchange => 'Interchange';

  @override
  String get stationInfo => 'Station Info';

  @override
  String get statistics => 'Statistics';

  @override
  String get totalTrips => 'Total Trips';

  @override
  String get totalSpent => 'Total Spent';

  @override
  String get totalDistance => 'Total Distance';

  @override
  String get averageFare => 'Average Fare';

  @override
  String get mostVisited => 'Most Visited';

  @override
  String get weeklySpending => 'This Week';

  @override
  String get monthlySpending => 'This Month';

  @override
  String get thisMonth => 'This Month';

  @override
  String get lastMonth => 'Last Month';

  @override
  String km(String value) {
    return '$value km';
  }

  @override
  String minutes(int value) {
    return '$value min';
  }

  @override
  String taka(String amount) {
    return '৳$amount';
  }

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get bangla => 'বাংলা';

  @override
  String get security => 'Security';

  @override
  String get faceId => 'Face ID / Biometrics';

  @override
  String get privacy => 'Privacy';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get feedback => 'Send Feedback';

  @override
  String get help => 'Help & Support';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get noCard => 'No Card Scanned';

  @override
  String get noCardDescription => 'Tap Scan Card to read your Rapid Pass.';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get viewStatistics => 'Statistics';

  @override
  String get viewRechargeHistory => 'Recharge History';

  @override
  String get search => 'Search';

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get noResults => 'No results';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get featureNotAvailable => 'This feature is not available yet.';
}
