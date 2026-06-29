// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'Rapid Pass BD';

  @override
  String get appTagline => 'ঢাকা মেট্রো র‍্যাপিড পাস';

  @override
  String get tabHome => 'হোম';

  @override
  String get tabHistory => 'ইতিহাস';

  @override
  String get tabFare => 'ভাড়া';

  @override
  String get tabMap => 'মানচিত্র';

  @override
  String get tabSettings => 'সেটিংস';

  @override
  String get balance => 'ব্যালেন্স';

  @override
  String get currentBalance => 'বর্তমান ব্যালেন্স';

  @override
  String get remainingBalance => 'অবশিষ্ট ব্যালেন্স';

  @override
  String get lowBalance => 'কম ব্যালেন্স';

  @override
  String get criticalBalance => 'ব্যালেন্স সংকটজনক';

  @override
  String get scanCard => 'কার্ড স্ক্যান করুন';

  @override
  String get scanning => 'স্ক্যান হচ্ছে...';

  @override
  String get holdCardNear => 'আপনার র‍্যাপিড পাস কার্ডটি ফোনের উপরের দিকে ধরুন';

  @override
  String get scanSuccess => 'কার্ড সফলভাবে পড়া হয়েছে';

  @override
  String get scanFailed => 'স্ক্যান ব্যর্থ হয়েছে';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get demoMode => 'ডেমো মোড';

  @override
  String get demoModeDescription =>
      'প্রদর্শনী তথ্য ব্যবহার করা হচ্ছে। লাইভ তথ্যের জন্য কার্ড স্ক্যান করুন।';

  @override
  String get nfcUnavailable => 'NFC উপলব্ধ নেই';

  @override
  String get nfcDisabled => 'NFC অক্ষম আছে';

  @override
  String get nfcUnsupportedCard => 'অসমর্থিত কার্ড';

  @override
  String get nfcReadFailure => 'কার্ড পড়া যায়নি';

  @override
  String get nfcPermissionDenied => 'NFC অনুমতি অস্বীকৃত';

  @override
  String get nfcTimeout => 'স্ক্যান সময় শেষ';

  @override
  String get openSettings => 'সেটিংস খুলুন';

  @override
  String get cardNumber => 'কার্ড নম্বর';

  @override
  String get cardType => 'কার্ডের ধরন';

  @override
  String get cardStatus => 'কার্ডের অবস্থা';

  @override
  String get issueDate => 'ইস্যু তারিখ';

  @override
  String get expiryDate => 'মেয়াদ শেষ তারিখ';

  @override
  String get lastRecharge => 'সর্বশেষ রিচার্জ';

  @override
  String get lastScan => 'সর্বশেষ স্ক্যান';

  @override
  String get rapidPass => 'র‍্যাপিড পাস';

  @override
  String get mrtPass => 'এমআরটি পাস';

  @override
  String get studentPass => 'ছাত্র পাস';

  @override
  String get seniorPass => 'প্রবীণ নাগরিক পাস';

  @override
  String get cardActive => 'সক্রিয়';

  @override
  String get cardInactive => 'নিষ্ক্রিয়';

  @override
  String get cardBlocked => 'ব্লক করা';

  @override
  String get cardExpired => 'মেয়াদোত্তীর্ণ';

  @override
  String get tripHistory => 'ভ্রমণ ইতিহাস';

  @override
  String get recentTrips => 'সাম্প্রতিক ভ্রমণ';

  @override
  String get noTrips => 'এখনো কোনো ভ্রমণ নেই';

  @override
  String get noTripsDescription =>
      'আপনার ভ্রমণ ইতিহাস দেখতে র‍্যাপিড পাস কার্ড স্ক্যান করুন।';

  @override
  String get from => 'থেকে';

  @override
  String get to => 'পর্যন্ত';

  @override
  String get fare => 'ভাড়া';

  @override
  String get distance => 'দূরত্ব';

  @override
  String get duration => 'সময়কাল';

  @override
  String get departure => 'প্রস্থান';

  @override
  String get arrival => 'আগমন';

  @override
  String get journey => 'যাত্রা';

  @override
  String get recharge => 'রিচার্জ';

  @override
  String get rechargeHistory => 'রিচার্জ ইতিহাস';

  @override
  String get rechargeAmount => 'রিচার্জ পরিমাণ';

  @override
  String get fareCalculator => 'ভাড়া ক্যালকুলেটর';

  @override
  String get selectOrigin => 'উৎস স্টেশন নির্বাচন করুন';

  @override
  String get selectDestination => 'গন্তব্য স্টেশন নির্বাচন করুন';

  @override
  String get calculate => 'হিসাব করুন';

  @override
  String get swapStations => 'স্টেশন পরিবর্তন করুন';

  @override
  String get estimatedFare => 'আনুমানিক ভাড়া';

  @override
  String get estimatedTime => 'আনুমানিক সময়';

  @override
  String get stationsCount => 'স্টেশন';

  @override
  String get routeSummary => 'রুটের সারসংক্ষেপ';

  @override
  String get selectBothStations =>
      'ভাড়া হিসাব করতে উভয় স্টেশন নির্বাচন করুন।';

  @override
  String get metroMap => 'মেট্রো মানচিত্র';

  @override
  String get searchStation => 'স্টেশন খুঁজুন';

  @override
  String get allLines => 'সব লাইন';

  @override
  String get mrtLine6 => 'এমআরটি লাইন ৬';

  @override
  String get mrtLine5 => 'এমআরটি লাইন ৫';

  @override
  String get interchange => 'ইন্টারচেঞ্জ';

  @override
  String get stationInfo => 'স্টেশন তথ্য';

  @override
  String get statistics => 'পরিসংখ্যান';

  @override
  String get totalTrips => 'মোট ভ্রমণ';

  @override
  String get totalSpent => 'মোট খরচ';

  @override
  String get totalDistance => 'মোট দূরত্ব';

  @override
  String get averageFare => 'গড় ভাড়া';

  @override
  String get mostVisited => 'সবচেয়ে বেশি পরিদর্শন';

  @override
  String get weeklySpending => 'এই সপ্তাহ';

  @override
  String get monthlySpending => 'এই মাস';

  @override
  String get thisMonth => 'এই মাস';

  @override
  String get lastMonth => 'গত মাস';

  @override
  String km(String value) {
    return '$value কিমি';
  }

  @override
  String minutes(int value) {
    return '$value মিনিট';
  }

  @override
  String taka(String amount) {
    return '৳$amount';
  }

  @override
  String get settings => 'সেটিংস';

  @override
  String get appearance => 'রূপ';

  @override
  String get themeLight => 'আলো';

  @override
  String get themeDark => 'অন্ধকার';

  @override
  String get themeSystem => 'সিস্টেম';

  @override
  String get language => 'ভাষা';

  @override
  String get english => 'English';

  @override
  String get bangla => 'বাংলা';

  @override
  String get security => 'নিরাপত্তা';

  @override
  String get faceId => 'ফেস আইডি / বায়োমেট্রিক্স';

  @override
  String get privacy => 'গোপনীয়তা';

  @override
  String get about => 'সম্পর্কে';

  @override
  String get version => 'সংস্করণ';

  @override
  String get feedback => 'মতামত পাঠান';

  @override
  String get help => 'সাহায্য ও সহায়তা';

  @override
  String get today => 'আজ';

  @override
  String get yesterday => 'গতকাল';

  @override
  String get noCard => 'কোনো কার্ড স্ক্যান হয়নি';

  @override
  String get noCardDescription =>
      'আপনার র‍্যাপিড পাস পড়তে স্ক্যান কার্ড ট্যাপ করুন।';

  @override
  String get quickActions => 'দ্রুত কাজ';

  @override
  String get viewStatistics => 'পরিসংখ্যান';

  @override
  String get viewRechargeHistory => 'রিচার্জ ইতিহাস';

  @override
  String get search => 'অনুসন্ধান';

  @override
  String get cancel => 'বাতিল';

  @override
  String get done => 'সম্পন্ন';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get error => 'ত্রুটি';

  @override
  String get retry => 'পুনরায় চেষ্টা';

  @override
  String get loading => 'লোড হচ্ছে...';

  @override
  String get noResults => 'কোনো ফলাফল নেই';

  @override
  String get comingSoon => 'শীঘ্রই আসছে';

  @override
  String get featureNotAvailable => 'এই বৈশিষ্ট্য এখনো উপলব্ধ নেই।';
}
