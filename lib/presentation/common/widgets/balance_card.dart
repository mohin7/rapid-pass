import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/rapid_pass_card.dart';
import 'package:intl/intl.dart';

/// Hero balance card shown prominently on the home screen.
/// Displays balance, card info, and status with gradient background.
class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.card,
    this.onTap,
  });

  final RapidPassCard card;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: card.isLowBalance
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.warning.withOpacity(0.9),
                    AppColors.warning.withOpacity(0.7),
                  ],
                )
              : AppColors.cardGradient,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: -50,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),
              ),
              // Card Content
              Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPaddingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: AppSpacing.xxl),
                    _buildBalance(context),
                    const SizedBox(height: AppSpacing.xxl),
                    _buildFooter(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DMTCL',
              style: AppTypography.overline.copyWith(
                color: Colors.white.withOpacity(0.7),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              card.type.displayName,
              style: AppTypography.titleSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        _StatusBadge(status: card.status, isDemo: card.isDemo),
      ],
    );
  }

  Widget _buildBalance(BuildContext context) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Balance',
          style: AppTypography.caption.copyWith(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '৳',
                style: AppTypography.currencySymbol.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              formatter.format(card.balance),
              style: AppTypography.balanceLarge.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
        if (card.isLowBalance)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
                const SizedBox(width: 4),
                Text(
                  card.isCriticalBalance ? 'Balance Critical' : 'Low Balance',
                  style: AppTypography.caption.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final dateFormatter = DateFormat('MMM dd, yyyy');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Card Number',
              style: AppTypography.caption.copyWith(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            Text(
              card.cardNumber,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Valid Until',
              style: AppTypography.caption.copyWith(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            Text(
              dateFormatter.format(card.expiryDate),
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, required this.isDemo});
  final CardStatus status;
  final bool isDemo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDemo ? AppColors.warning : _statusColor(status),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isDemo ? 'DEMO' : status.displayName.toUpperCase(),
            style: AppTypography.overline.copyWith(
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(CardStatus status) {
    switch (status) {
      case CardStatus.active:
        return AppColors.success;
      case CardStatus.inactive:
        return AppColors.inactiveCard;
      case CardStatus.blocked:
        return AppColors.error;
      case CardStatus.expired:
        return AppColors.expiredCard;
    }
  }
}
