import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/rapid_pass_card.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/station.dart';
import '../../core/services/nfc_service.dart';
import '../../data/datasources/local/station_data.dart';

// ── SharedPreferences ─────────────────────────────────────────────────────────

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

// ── Theme & Settings ──────────────────────────────────────────────────────────

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier(SharedPreferences prefs)
      : _prefs = prefs,
        super(_loadFromPrefs(prefs));

  final SharedPreferences _prefs;

  static AppSettings _loadFromPrefs(SharedPreferences prefs) {
    final themeStr = prefs.getString(AppConstants.keyThemeMode) ?? 'system';
    final localeStr = prefs.getString(AppConstants.keyLocale) ?? 'en';
    final biometrics = prefs.getBool(AppConstants.keyBiometrics) ?? false;
    return AppSettings(
      themeMode: _parseThemeMode(themeStr),
      locale: localeStr,
      biometricsEnabled: biometrics,
    );
  }

  static AppThemeMode _parseThemeMode(String str) {
    switch (str) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system;
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _prefs.setString(AppConstants.keyThemeMode, mode.name);
  }

  Future<void> setLocale(String locale) async {
    state = state.copyWith(locale: locale);
    await _prefs.setString(AppConstants.keyLocale, locale);
  }

  Future<void> setBiometrics(bool enabled) async {
    state = state.copyWith(biometricsEnabled: enabled);
    await _prefs.setBool(AppConstants.keyBiometrics, enabled);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) {
    final prefs = ref.watch(sharedPreferencesProvider).maybeWhen(
          data: (p) => p,
          orElse: () => null,
        );
    if (prefs == null) {
      return SettingsNotifier(
        throw UnimplementedError('SharedPreferences not ready'),
      );
    }
    return SettingsNotifier(prefs);
  },
);

// Safe settings provider that initializes with defaults
final safeSettingsProvider = Provider<AppSettings>((ref) {
  return ref.watch(settingsProvider);
});

class AppSettings {
  const AppSettings({
    required this.themeMode,
    required this.locale,
    required this.biometricsEnabled,
  });

  final AppThemeMode themeMode;
  final String locale;
  final bool biometricsEnabled;

  AppSettings copyWith({
    AppThemeMode? themeMode,
    String? locale,
    bool? biometricsEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
    );
  }
}

enum AppThemeMode { light, dark, system }

// ── Card State ────────────────────────────────────────────────────────────────

class CardStateNotifier extends StateNotifier<CardState> {
  CardStateNotifier(this._nfcService) : super(const CardState.initial());

  final NfcService _nfcService;

  Future<void> scanCard() async {
    state = const CardState.scanning();
    final result = await _nfcService.scanCard();
    switch (result) {
      case NfcScanSuccess(:final card, :final transactions):
        state = CardState.loaded(card: card, transactions: transactions);
      case NfcScanError(:final type, :final message):
        state = CardState.error(type: type, message: message);
    }
  }

  Future<void> scanMockCard() async {
    state = const CardState.scanning();
    final result = await _nfcService.scanMockCard();
    switch (result) {
      case NfcScanSuccess(:final card, :final transactions):
        state = CardState.loaded(card: card, transactions: transactions);
      case NfcScanError(:final type, :final message):
        state = CardState.error(type: type, message: message);
    }
  }

  Future<void> stopScan() async {
    await _nfcService.stopScan();
    state = const CardState.initial();
  }

  void clearCard() {
    state = const CardState.initial();
  }
}

final cardStateProvider =
    StateNotifierProvider<CardStateNotifier, CardState>((ref) {
  final nfcService = ref.watch(nfcServiceProvider);
  return CardStateNotifier(nfcService);
});

sealed class CardState {
  const CardState();
  const factory CardState.initial() = CardStateInitial;
  const factory CardState.scanning() = CardStateScanning;
  const factory CardState.loaded({
    required RapidPassCard card,
    required List<CardTransaction> transactions,
  }) = CardStateLoaded;
  const factory CardState.error({
    required NfcErrorType type,
    String? message,
  }) = CardStateError;
}

class CardStateInitial extends CardState {
  const CardStateInitial();
}

class CardStateScanning extends CardState {
  const CardStateScanning();
}

class CardStateLoaded extends CardState {
  const CardStateLoaded({required this.card, required this.transactions});
  final RapidPassCard card;
  final List<CardTransaction> transactions;
}

class CardStateError extends CardState {
  const CardStateError({required this.type, this.message});
  final NfcErrorType type;
  final String? message;
}

// ── Station Providers ─────────────────────────────────────────────────────────

final allStationsProvider = Provider<List<MetroStation>>((ref) {
  return StationData.allStations;
});

final stationSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredStationsProvider = Provider<List<MetroStation>>((ref) {
  final query = ref.watch(stationSearchQueryProvider);
  final stations = ref.watch(allStationsProvider);
  if (query.isEmpty) return stations;
  return StationData.searchByName(query);
});

// ── Fare Calculator ───────────────────────────────────────────────────────────

class FareCalculatorState {
  const FareCalculatorState({
    this.fromStation,
    this.toStation,
    this.result,
  });

  final MetroStation? fromStation;
  final MetroStation? toStation;
  final FareResult? result;

  FareCalculatorState copyWith({
    MetroStation? fromStation,
    MetroStation? toStation,
    FareResult? result,
    bool clearResult = false,
  }) {
    return FareCalculatorState(
      fromStation: fromStation ?? this.fromStation,
      toStation: toStation ?? this.toStation,
      result: clearResult ? null : (result ?? this.result),
    );
  }
}

class FareCalculatorNotifier extends StateNotifier<FareCalculatorState> {
  FareCalculatorNotifier() : super(const FareCalculatorState());

  void setFromStation(MetroStation station) {
    state = state.copyWith(fromStation: station, clearResult: true);
  }

  void setToStation(MetroStation station) {
    state = state.copyWith(toStation: station, clearResult: true);
  }

  void swapStations() {
    state = FareCalculatorState(
      fromStation: state.toStation,
      toStation: state.fromStation,
    );
    if (state.fromStation != null && state.toStation != null) {
      calculate();
    }
  }

  void calculate() {
    final from = state.fromStation;
    final to = state.toStation;
    if (from == null || to == null) return;

    final fare = StationData.calculateFare(from, to);
    final distance = StationData.distanceBetween(from, to);
    final minutes = StationData.estimatedMinutes(from, to);
    final route = StationData.getRoute(from, to);

    state = state.copyWith(
      result: FareResult(
        fromStation: from,
        toStation: to,
        fare: fare,
        distance: distance,
        estimatedMinutes: minutes,
        stationsCount: route.length,
        route: route,
      ),
    );
  }

  void reset() {
    state = const FareCalculatorState();
  }
}

final fareCalculatorProvider =
    StateNotifierProvider<FareCalculatorNotifier, FareCalculatorState>(
        (ref) => FareCalculatorNotifier());

// ── Statistics Provider ───────────────────────────────────────────────────────

final statisticsProvider = Provider<TravelStatistics?>((ref) {
  final cardState = ref.watch(cardStateProvider);
  if (cardState is! CardStateLoaded) return null;
  final transactions = cardState.transactions
      .where((t) => t.isJourney)
      .toList();
  if (transactions.isEmpty) return null;

  final totalSpent = transactions.fold<double>(0, (sum, t) => sum + t.fare);
  final totalDistance =
      transactions.fold<double>(0, (sum, t) => sum + t.distance);
  final now = DateTime.now();
  final weekAgo = now.subtract(const Duration(days: 7));
  final monthAgo = now.subtract(const Duration(days: 30));
  final lastMonthStart = DateTime(now.year, now.month - 1, 1);
  final lastMonthEnd = DateTime(now.year, now.month, 0);

  final weeklyTrips =
      transactions.where((t) => t.entryTime.isAfter(weekAgo)).toList();
  final monthlyTrips =
      transactions.where((t) => t.entryTime.isAfter(monthAgo)).toList();
  final lastMonthTrips = transactions
      .where((t) =>
          t.entryTime.isAfter(lastMonthStart) &&
          t.entryTime.isBefore(lastMonthEnd))
      .toList();

  final weeklySpending =
      weeklyTrips.fold<double>(0, (sum, t) => sum + t.fare);
  final monthlySpending =
      monthlyTrips.fold<double>(0, (sum, t) => sum + t.fare);

  // Find most visited station
  final stationCount = <String, int>{};
  for (final t in transactions) {
    stationCount[t.entryStation] = (stationCount[t.entryStation] ?? 0) + 1;
    if (t.exitStation != null) {
      stationCount[t.exitStation!] =
          (stationCount[t.exitStation!] ?? 0) + 1;
    }
  }
  final mostVisited = stationCount.entries.isEmpty
      ? 'N/A'
      : stationCount.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;

  final distances = transactions.map((t) => t.distance).toList();
  distances.sort();

  return TravelStatistics(
    totalTrips: transactions.length,
    totalSpent: totalSpent,
    totalDistance: totalDistance,
    averageFare: transactions.isEmpty ? 0 : totalSpent / transactions.length,
    mostVisitedStation: mostVisited,
    weeklySpending: weeklySpending,
    monthlySpending: monthlySpending,
    lastMonthTrips: lastMonthTrips.length,
    thisMonthTrips: monthlyTrips.length,
    longestJourney: distances.isEmpty ? 0 : distances.last,
    shortestJourney: distances.isEmpty ? 0 : distances.first,
  );
});
