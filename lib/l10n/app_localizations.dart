import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Rapid Pass BD'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Dhaka Metro Rapid Pass'**
  String get appTagline;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tabHistory;

  /// No description provided for @tabFare.
  ///
  /// In en, this message translates to:
  /// **'Fare'**
  String get tabFare;

  /// No description provided for @tabMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get tabMap;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @remainingBalance.
  ///
  /// In en, this message translates to:
  /// **'Remaining Balance'**
  String get remainingBalance;

  /// No description provided for @lowBalance.
  ///
  /// In en, this message translates to:
  /// **'Low Balance'**
  String get lowBalance;

  /// No description provided for @criticalBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance Critical'**
  String get criticalBalance;

  /// No description provided for @scanCard.
  ///
  /// In en, this message translates to:
  /// **'Scan Card'**
  String get scanCard;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @holdCardNear.
  ///
  /// In en, this message translates to:
  /// **'Hold your Rapid Pass card near the top of your phone'**
  String get holdCardNear;

  /// No description provided for @scanSuccess.
  ///
  /// In en, this message translates to:
  /// **'Card Read Successfully'**
  String get scanSuccess;

  /// No description provided for @scanFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan Failed'**
  String get scanFailed;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @demoMode.
  ///
  /// In en, this message translates to:
  /// **'Demo Mode'**
  String get demoMode;

  /// No description provided for @demoModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Using demonstration data. Scan a real card for live data.'**
  String get demoModeDescription;

  /// No description provided for @nfcUnavailable.
  ///
  /// In en, this message translates to:
  /// **'NFC Not Available'**
  String get nfcUnavailable;

  /// No description provided for @nfcDisabled.
  ///
  /// In en, this message translates to:
  /// **'NFC is Disabled'**
  String get nfcDisabled;

  /// No description provided for @nfcUnsupportedCard.
  ///
  /// In en, this message translates to:
  /// **'Unsupported Card'**
  String get nfcUnsupportedCard;

  /// No description provided for @nfcReadFailure.
  ///
  /// In en, this message translates to:
  /// **'Could Not Read Card'**
  String get nfcReadFailure;

  /// No description provided for @nfcPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'NFC Permission Denied'**
  String get nfcPermissionDenied;

  /// No description provided for @nfcTimeout.
  ///
  /// In en, this message translates to:
  /// **'Scan Timed Out'**
  String get nfcTimeout;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @cardType.
  ///
  /// In en, this message translates to:
  /// **'Card Type'**
  String get cardType;

  /// No description provided for @cardStatus.
  ///
  /// In en, this message translates to:
  /// **'Card Status'**
  String get cardStatus;

  /// No description provided for @issueDate.
  ///
  /// In en, this message translates to:
  /// **'Issue Date'**
  String get issueDate;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @lastRecharge.
  ///
  /// In en, this message translates to:
  /// **'Last Recharge'**
  String get lastRecharge;

  /// No description provided for @lastScan.
  ///
  /// In en, this message translates to:
  /// **'Last Scan'**
  String get lastScan;

  /// No description provided for @rapidPass.
  ///
  /// In en, this message translates to:
  /// **'Rapid Pass'**
  String get rapidPass;

  /// No description provided for @mrtPass.
  ///
  /// In en, this message translates to:
  /// **'MRT Pass'**
  String get mrtPass;

  /// No description provided for @studentPass.
  ///
  /// In en, this message translates to:
  /// **'Student Pass'**
  String get studentPass;

  /// No description provided for @seniorPass.
  ///
  /// In en, this message translates to:
  /// **'Senior Citizen Pass'**
  String get seniorPass;

  /// No description provided for @cardActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get cardActive;

  /// No description provided for @cardInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get cardInactive;

  /// No description provided for @cardBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get cardBlocked;

  /// No description provided for @cardExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get cardExpired;

  /// No description provided for @tripHistory.
  ///
  /// In en, this message translates to:
  /// **'Trip History'**
  String get tripHistory;

  /// No description provided for @recentTrips.
  ///
  /// In en, this message translates to:
  /// **'Recent Trips'**
  String get recentTrips;

  /// No description provided for @noTrips.
  ///
  /// In en, this message translates to:
  /// **'No trips yet'**
  String get noTrips;

  /// No description provided for @noTripsDescription.
  ///
  /// In en, this message translates to:
  /// **'Scan your Rapid Pass card to see your trip history.'**
  String get noTripsDescription;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @fare.
  ///
  /// In en, this message translates to:
  /// **'Fare'**
  String get fare;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departure;

  /// No description provided for @arrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get arrival;

  /// No description provided for @journey.
  ///
  /// In en, this message translates to:
  /// **'Journey'**
  String get journey;

  /// No description provided for @recharge.
  ///
  /// In en, this message translates to:
  /// **'Recharge'**
  String get recharge;

  /// No description provided for @rechargeHistory.
  ///
  /// In en, this message translates to:
  /// **'Recharge History'**
  String get rechargeHistory;

  /// No description provided for @rechargeAmount.
  ///
  /// In en, this message translates to:
  /// **'Recharge Amount'**
  String get rechargeAmount;

  /// No description provided for @fareCalculator.
  ///
  /// In en, this message translates to:
  /// **'Fare Calculator'**
  String get fareCalculator;

  /// No description provided for @selectOrigin.
  ///
  /// In en, this message translates to:
  /// **'Select Origin'**
  String get selectOrigin;

  /// No description provided for @selectDestination.
  ///
  /// In en, this message translates to:
  /// **'Select Destination'**
  String get selectDestination;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @swapStations.
  ///
  /// In en, this message translates to:
  /// **'Swap Stations'**
  String get swapStations;

  /// No description provided for @estimatedFare.
  ///
  /// In en, this message translates to:
  /// **'Estimated Fare'**
  String get estimatedFare;

  /// No description provided for @estimatedTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated Time'**
  String get estimatedTime;

  /// No description provided for @stationsCount.
  ///
  /// In en, this message translates to:
  /// **'Stations'**
  String get stationsCount;

  /// No description provided for @routeSummary.
  ///
  /// In en, this message translates to:
  /// **'Route Summary'**
  String get routeSummary;

  /// No description provided for @selectBothStations.
  ///
  /// In en, this message translates to:
  /// **'Please select both stations to calculate the fare.'**
  String get selectBothStations;

  /// No description provided for @metroMap.
  ///
  /// In en, this message translates to:
  /// **'Metro Map'**
  String get metroMap;

  /// No description provided for @searchStation.
  ///
  /// In en, this message translates to:
  /// **'Search station'**
  String get searchStation;

  /// No description provided for @allLines.
  ///
  /// In en, this message translates to:
  /// **'All Lines'**
  String get allLines;

  /// No description provided for @mrtLine6.
  ///
  /// In en, this message translates to:
  /// **'MRT Line 6'**
  String get mrtLine6;

  /// No description provided for @mrtLine5.
  ///
  /// In en, this message translates to:
  /// **'MRT Line 5'**
  String get mrtLine5;

  /// No description provided for @interchange.
  ///
  /// In en, this message translates to:
  /// **'Interchange'**
  String get interchange;

  /// No description provided for @stationInfo.
  ///
  /// In en, this message translates to:
  /// **'Station Info'**
  String get stationInfo;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @totalTrips.
  ///
  /// In en, this message translates to:
  /// **'Total Trips'**
  String get totalTrips;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get totalSpent;

  /// No description provided for @totalDistance.
  ///
  /// In en, this message translates to:
  /// **'Total Distance'**
  String get totalDistance;

  /// No description provided for @averageFare.
  ///
  /// In en, this message translates to:
  /// **'Average Fare'**
  String get averageFare;

  /// No description provided for @mostVisited.
  ///
  /// In en, this message translates to:
  /// **'Most Visited'**
  String get mostVisited;

  /// No description provided for @weeklySpending.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get weeklySpending;

  /// No description provided for @monthlySpending.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get monthlySpending;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'{value} km'**
  String km(String value);

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{value} min'**
  String minutes(int value);

  /// No description provided for @taka.
  ///
  /// In en, this message translates to:
  /// **'৳{amount}'**
  String taka(String amount);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @bangla.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get bangla;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @faceId.
  ///
  /// In en, this message translates to:
  /// **'Face ID / Biometrics'**
  String get faceId;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get feedback;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get help;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @noCard.
  ///
  /// In en, this message translates to:
  /// **'No Card Scanned'**
  String get noCard;

  /// No description provided for @noCardDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap Scan Card to read your Rapid Pass.'**
  String get noCardDescription;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @viewStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get viewStatistics;

  /// No description provided for @viewRechargeHistory.
  ///
  /// In en, this message translates to:
  /// **'Recharge History'**
  String get viewRechargeHistory;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @featureNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'This feature is not available yet.'**
  String get featureNotAvailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
