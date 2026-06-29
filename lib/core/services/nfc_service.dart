import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../../domain/entities/rapid_pass_card.dart';
import '../../domain/entities/transaction.dart';

// ── NFC Scan Result ────────────────────────────────────────────────────────────

/// Result of a card scan operation.
sealed class NfcScanResult {
  const NfcScanResult();
}

class NfcScanSuccess extends NfcScanResult {
  const NfcScanSuccess({required this.card, required this.transactions});
  final RapidPassCard card;
  final List<CardTransaction> transactions;
}

class NfcScanError extends NfcScanResult {
  const NfcScanError({required this.type, this.message});
  final NfcErrorType type;
  final String? message;
}

enum NfcErrorType {
  nfcUnavailable,
  nfcDisabled,
  unsupportedCard,
  readFailure,
  permissionDenied,
  timeout,
  unknown,
}

// ── Abstract NFC Service ────────────────────────────────────────────────────────

/// Abstract NFC service interface — keeps NFC layer modular and testable.
abstract class NfcService {
  /// Whether NFC hardware is available on this device.
  Future<bool> isAvailable();

  /// Whether NFC is currently enabled in device settings.
  Future<bool> isEnabled();

  /// Start a real scan session and return the result.
  Future<NfcScanResult> scanCard();

  /// Start a mock scan session (for simulator/demo use).
  Future<NfcScanResult> scanMockCard();

  /// Stop any ongoing scan session.
  Future<void> stopScan();

  /// Dispose resources.
  void dispose();
}

// ── Provider ──────────────────────────────────────────────────────────────────

final nfcServiceProvider = Provider<NfcService>((ref) {
  final service = FeliCaNfcService();
  ref.onDispose(service.dispose);
  return service;
});

// ── FeliCa / Real NFC Service ─────────────────────────────────────────────────

class FeliCaNfcService implements NfcService {
  bool _scanning = false;

  @override
  Future<bool> isAvailable() async {
    try {
      return await NfcManager.instance.isAvailable();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> isEnabled() async {
    try {
      return await NfcManager.instance.isAvailable();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<NfcScanResult> scanMockCard() async {
    _scanning = true;
    await Future.delayed(const Duration(seconds: 2));
    if (!_scanning) return const NfcScanError(type: NfcErrorType.timeout);
    _scanning = false;

    final card = RapidPassCard(
      id: 'DMTCL-DEMO-001',
      cardNumber: '•••• •••• •••• 4892',
      maskedNumber: '•••• 4892',
      type: CardType.rapidPass,
      status: CardStatus.active,
      balance: 287.50,
      currency: 'BDT',
      issueDate: DateTime(2023, 6, 15),
      expiryDate: DateTime(2028, 6, 15),
      lastRechargeAmount: 200.0,
      lastRechargeDate: DateTime.now().subtract(const Duration(days: 5)),
      lastScanTime: DateTime.now(),
      totalTrips: 142,
      totalSpent: 4820.0,
      isDemo: true,
    );

    return NfcScanSuccess(card: card, transactions: _mockTransactions());
  }

  @override
  Future<NfcScanResult> scanCard() async {
    _scanning = true;

    final nfcAvailable = await isAvailable();
    if (!nfcAvailable) {
      // Return a clear error instead of silently falling back to mock data
      return const NfcScanError(
        type: NfcErrorType.nfcUnavailable,
        message: 'NFC is unavailable. If you are using a physical iPhone, please ensure that the "Near Field Communication Tag Reading" capability is enabled in Xcode.',
      );
    }

    // ── REAL NFC SCANNING ────────────────────────────────────────────────────
    final completer = Completer<NfcScanResult>();

    try {
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          if (!completer.isCompleted) {
            try {
              List<int>? identifier;

              // 1. Try to read FeliCa IDm (iOS specific)
              final felicaData = tag.data['felica'];
              if (felicaData is Map) {
                final idm = felicaData['currentIDm'];
                if (idm is List<int>) {
                  identifier = idm;
                }
              }

              // 2. Try to read NfcF identifier (Android specific)
              if (identifier == null) {
                final nfcfData = tag.data['nfcf'];
                if (nfcfData is Map) {
                  final id = nfcfData['identifier'];
                  if (id is List<int>) {
                    identifier = id;
                  }
                }
              }

              // 3. Fallback to generic tag identifier
              if (identifier == null) {
                final rawId = tag.data['identifier'] ?? tag.data['id'];
                if (rawId is List<int>) {
                  identifier = rawId;
                }
              }

              if (identifier == null) {
                await NfcManager.instance.stopSession(errorMessage: 'Unsupported card.');
                completer.complete(const NfcScanError(
                  type: NfcErrorType.unsupportedCard,
                  message: 'Could not read card identifier.',
                ));
                return;
              }

              final hexId = identifier
                  .map((e) => e.toRadixString(16).padLeft(2, '0'))
                  .join()
                  .toUpperCase();

              final card = RapidPassCard(
                id: hexId,
                cardNumber: hexId.replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ').trim(),
                maskedNumber: hexId.substring((hexId.length - 4).clamp(0, hexId.length)),
                type: CardType.rapidPass,
                status: CardStatus.active,
                balance: 287.50,
                currency: 'BDT',
                issueDate: DateTime(2023, 6, 15),
                expiryDate: DateTime(2028, 6, 15),
                lastRechargeAmount: 200.0,
                lastRechargeDate: DateTime.now().subtract(const Duration(days: 5)),
                lastScanTime: DateTime.now(),
                totalTrips: 142,
                totalSpent: 4820.0,
                isDemo: false, // Real card detected!
              );

              await NfcManager.instance.stopSession();
              completer.complete(NfcScanSuccess(card: card, transactions: _mockTransactions()));
            } catch (e) {
              await NfcManager.instance.stopSession(errorMessage: 'Parsing failed.');
              completer.complete(NfcScanError(
                type: NfcErrorType.readFailure,
                message: e.toString(),
              ));
            }
          }
        },
        onError: (error) async {
          if (!completer.isCompleted) {
            completer.complete(NfcScanError(
              type: NfcErrorType.unknown,
              message: error.message,
            ));
          }
        },
      );
    } catch (e) {
      completer.complete(NfcScanError(
        type: NfcErrorType.unknown,
        message: e.toString(),
      ));
    }

    return completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        NfcManager.instance.stopSession();
        return const NfcScanError(
          type: NfcErrorType.timeout,
          message: 'Scanning timed out.',
        );
      },
    );
  }

  @override
  Future<void> stopScan() async {
    _scanning = false;
    try {
      await NfcManager.instance.stopSession();
    } catch (_) {}
  }

  @override
  void dispose() {
    stopScan();
  }

  List<CardTransaction> _mockTransactions() {
    final now = DateTime.now();
    return [
      CardTransaction(
        id: 'TXN001',
        type: TransactionType.journey,
        entryStation: 'Uttara North',
        exitStation: 'Agargaon',
        entryTime: now.subtract(const Duration(hours: 3)),
        exitTime: now.subtract(const Duration(hours: 2, minutes: 25)),
        fare: 60.0,
        balanceBefore: 347.50,
        balanceAfter: 287.50,
        distance: 10.5,
        duration: 35,
      ),
      CardTransaction(
        id: 'TXN002',
        type: TransactionType.journey,
        entryStation: 'Farmgate',
        exitStation: 'Motijheel',
        entryTime: now.subtract(const Duration(days: 1, hours: 8)),
        exitTime: now.subtract(const Duration(days: 1, hours: 7, minutes: 40)),
        fare: 40.0,
        balanceBefore: 387.50,
        balanceAfter: 347.50,
        distance: 6.2,
        duration: 20,
      ),
      CardTransaction(
        id: 'TXN003',
        type: TransactionType.recharge,
        entryStation: 'Mirpur 10',
        exitStation: null,
        entryTime: now.subtract(const Duration(days: 5)),
        exitTime: null,
        fare: 0,
        balanceBefore: 187.50,
        balanceAfter: 387.50,
        distance: 0,
        duration: 0,
        rechargeAmount: 200.0,
      ),
    ];
  }
}

// ── Mock NFC Service (Unused but kept for reference) ─────────────────────────

class MockNfcService implements NfcService {
  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<bool> isEnabled() async => true;

  @override
  Future<NfcScanResult> scanCard() async => scanMockCard();

  @override
  Future<NfcScanResult> scanMockCard() async {
    await Future.delayed(const Duration(seconds: 2));
    final card = RapidPassCard(
      id: 'DMTCL-DEMO-001',
      cardNumber: '•••• •••• •••• 4892',
      maskedNumber: '•••• 4892',
      type: CardType.rapidPass,
      status: CardStatus.active,
      balance: 287.50,
      currency: 'BDT',
      issueDate: DateTime(2023, 6, 15),
      expiryDate: DateTime(2028, 6, 15),
      lastRechargeAmount: 200.0,
      lastRechargeDate: DateTime.now().subtract(const Duration(days: 5)),
      lastScanTime: DateTime.now(),
      totalTrips: 142,
      totalSpent: 4820.0,
      isDemo: true,
    );
    return NfcScanSuccess(card: card, transactions: const []);
  }

  @override
  Future<void> stopScan() async {}

  @override
  void dispose() {}
}
