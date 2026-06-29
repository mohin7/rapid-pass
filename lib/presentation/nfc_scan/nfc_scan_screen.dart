import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/services/nfc_service.dart';
import '../../data/providers/app_providers.dart';
import '../common/widgets/nfc_scan_animation.dart';

/// Full-screen NFC scan modal.
/// Handles: idle, scanning, success, error, unsupported states.
class NfcScanScreen extends ConsumerStatefulWidget {
  const NfcScanScreen({super.key});

  @override
  ConsumerState<NfcScanScreen> createState() => _NfcScanScreenState();
}

class _NfcScanScreenState extends ConsumerState<NfcScanScreen> {
  _ScanUIState _uiState = _ScanUIState.idle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardState = ref.watch(cardStateProvider);
    final isNfcUnavailable = cardState is CardStateError && cardState.type == NfcErrorType.nfcUnavailable;

    // Sync UI state with card state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      switch (cardState) {
        case CardStateScanning():
          if (_uiState != _ScanUIState.scanning) {
            setState(() => _uiState = _ScanUIState.scanning);
          }
        case CardStateLoaded():
          if (_uiState != _ScanUIState.success) {
            setState(() => _uiState = _ScanUIState.success);
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) GoRouter.of(context).pop();
            });
          }
        case CardStateError():
          if (_uiState != _ScanUIState.error) {
            setState(() => _uiState = _ScanUIState.error);
          }
        default:
          break;
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(cardStateProvider.notifier).stopScan();
            context.pop();
          },
        ),
        title: const Text('Scan Card'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          child: Column(
            children: [
              const Spacer(),
              _buildAnimation(),
              const SizedBox(height: AppSpacing.xxxl),
              _buildStatusText(context, isDark, isNfcUnavailable),
              const Spacer(),
              _buildActions(context, ref, isNfcUnavailable),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    return NfcScanAnimation(
      isScanning: _uiState == _ScanUIState.scanning,
      isSuccess: _uiState == _ScanUIState.success,
      isError: _uiState == _ScanUIState.error,
    );
  }

  Widget _buildStatusText(BuildContext context, bool isDark, bool isNfcUnavailable) {
    final subtleColor = isDark
        ? AppColors.onSurfaceVariantDark
        : AppColors.onSurfaceVariantLight;

    final (title, subtitle, color) = switch (_uiState) {
      _ScanUIState.idle => (
          'Ready to Scan',
          'Tap the button below to start scanning\nyour Rapid Pass card',
          AppColors.primary,
        ),
      _ScanUIState.scanning => (
          'Scanning...',
          'Hold your Rapid Pass card near\nthe top of your iPhone',
          AppColors.primary,
        ),
      _ScanUIState.success => (
          'Card Read Successfully',
          'Your Rapid Pass data has been loaded.\nReturning to home...',
          AppColors.success,
        ),
      _ScanUIState.error => isNfcUnavailable
          ? (
              'NFC Unsupported',
              'NFC is unavailable. If you are using a physical iPhone, please ensure the "Near Field Communication Tag Reading" capability is enabled in Xcode.\n\nAlternatively, you can load a simulated card to explore the app.',
              AppColors.error,
            )
          : (
              'Scan Failed',
              'Could not read the card. Please try again\nor check that NFC is enabled.',
              AppColors.error,
            ),
      _ScanUIState.unsupported => (
          'Unsupported Card',
          'This card is not a Dhaka Metro Rapid Pass.\nPlease use a valid MRT card.',
          AppColors.warning,
        ),
    };

    return Column(
      children: [
        Text(
          title,
          style: AppTypography.headlineMedium.copyWith(color: color),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: AppSpacing.md),
        Text(
          subtitle,
          style: AppTypography.bodyMedium.copyWith(color: subtleColor),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
        const SizedBox(height: AppSpacing.lg),
        _NfcInfoNote(isDark: isDark),
      ],
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref, bool isNfcUnavailable) {
    return switch (_uiState) {
      _ScanUIState.idle => _ScanButton(
          onTap: () => ref.read(cardStateProvider.notifier).scanCard(),
        ),
      _ScanUIState.scanning => _CancelButton(
          onTap: () {
            ref.read(cardStateProvider.notifier).stopScan();
            setState(() => _uiState = _ScanUIState.idle);
          },
        ),
      _ScanUIState.success => const SizedBox.shrink(),
      _ScanUIState.error || _ScanUIState.unsupported => Column(
          children: [
            if (isNfcUnavailable) ...[
              _ScanButton(
                label: 'Use Demo Card',
                onTap: () {
                  setState(() => _uiState = _ScanUIState.idle);
                  ref.read(cardStateProvider.notifier).scanMockCard();
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ] else ...[
              _ScanButton(
                label: 'Try Again',
                onTap: () {
                  setState(() => _uiState = _ScanUIState.idle);
                  ref.read(cardStateProvider.notifier).scanCard();
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            _CancelButton(onTap: () => context.pop()),
          ],
        ),
    };
  }
}

enum _ScanUIState { idle, scanning, success, error, unsupported }

class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.onTap, this.label = 'Start Scan'});
  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.nfc_rounded, color: Colors.white, size: 22),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        'Cancel',
        style: AppTypography.labelLarge.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _NfcInfoNote extends StatelessWidget {
  const _NfcInfoNote({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline,
            size: 14,
            color: isDark
                ? AppColors.onSurfaceVariantDark
                : AppColors.onSurfaceVariantLight,
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              'Demo mode — no real NFC hardware required',
              style: AppTypography.caption.copyWith(
                color: isDark
                    ? AppColors.onSurfaceVariantDark
                    : AppColors.onSurfaceVariantLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
