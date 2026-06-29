import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/transaction.dart';

/// Trip card for the history timeline.
/// Supports expansion to show more details.
class TripCard extends StatefulWidget {
  const TripCard({
    super.key,
    required this.transaction,
    this.isExpanded = false,
    this.animationIndex = 0,
  });

  final CardTransaction transaction;
  final bool isExpanded;
  final int animationIndex;

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRecharge = widget.transaction.isRecharge;

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Column(
          children: [
            _buildHeader(context, isRecharge, isDark),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: _buildExpandedDetails(context, isDark),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: widget.animationIndex * 60))
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.05, end: 0);
  }

  Widget _buildHeader(
      BuildContext context, bool isRecharge, bool isDark) {
    final timeFormatter = DateFormat('HH:mm');
    final tx = widget.transaction;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Row(
        children: [
          _TransactionIcon(isRecharge: isRecharge),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isRecharge)
                  Text(
                    'Recharge',
                    style: AppTypography.titleSmall.copyWith(
                      color: isDark
                          ? AppColors.onSurfaceDark
                          : AppColors.onSurfaceLight,
                    ),
                  )
                else
                  Text(
                    '${tx.entryStation} → ${tx.exitStation}',
                    style: AppTypography.titleSmall.copyWith(
                      color: isDark
                          ? AppColors.onSurfaceDark
                          : AppColors.onSurfaceLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 2),
                Text(
                  timeFormatter.format(tx.entryTime),
                  style: AppTypography.caption.copyWith(
                    color: isDark
                        ? AppColors.onSurfaceVariantDark
                        : AppColors.onSurfaceVariantLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isRecharge
                    ? '+৳${tx.rechargeAmount?.toStringAsFixed(0)}'
                    : '-৳${tx.fare.toStringAsFixed(0)}',
                style: AppTypography.titleSmall.copyWith(
                  color: isRecharge ? AppColors.success : AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Bal: ৳${tx.balanceAfter.toStringAsFixed(2)}',
                style: AppTypography.caption.copyWith(
                  color: isDark
                      ? AppColors.onSurfaceVariantDark
                      : AppColors.onSurfaceVariantLight,
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(
            _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            size: 18,
            color: isDark
                ? AppColors.onSurfaceVariantDark
                : AppColors.onSurfaceVariantLight,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedDetails(BuildContext context, bool isDark) {
    final tx = widget.transaction;
    final dateFormatter = DateFormat('MMM dd, yyyy • HH:mm');
    final subtleText = isDark
        ? AppColors.onSurfaceVariantDark
        : AppColors.onSurfaceVariantLight;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        children: [
          if (!tx.isRecharge) ...[
            _DetailRow(
              label: 'Entry',
              value: '${tx.entryStation}\n${dateFormatter.format(tx.entryTime)}',
              subtleColor: subtleText,
            ),
            if (tx.exitStation != null && tx.exitTime != null)
              _DetailRow(
                label: 'Exit',
                value:
                    '${tx.exitStation}\n${dateFormatter.format(tx.exitTime!)}',
                subtleColor: subtleText,
              ),
            _DetailRow(
              label: 'Distance',
              value: '${tx.distance.toStringAsFixed(1)} km',
              subtleColor: subtleText,
            ),
            _DetailRow(
              label: 'Duration',
              value: '${tx.duration} minutes',
              subtleColor: subtleText,
            ),
          ] else
            _DetailRow(
              label: 'Date',
              value: dateFormatter.format(tx.entryTime),
              subtleColor: subtleText,
            ),
          _DetailRow(
            label: 'Balance Before',
            value: '৳${tx.balanceBefore.toStringAsFixed(2)}',
            subtleColor: subtleText,
          ),
          _DetailRow(
            label: 'Balance After',
            value: '৳${tx.balanceAfter.toStringAsFixed(2)}',
            subtleColor: subtleText,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TransactionIcon extends StatelessWidget {
  const _TransactionIcon({required this.isRecharge});
  final bool isRecharge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isRecharge
            ? AppColors.successLight
            : AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isRecharge ? Icons.add_card_rounded : Icons.train_rounded,
        color: isRecharge ? AppColors.success : AppColors.primary,
        size: 20,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.subtleColor,
    this.isLast = false,
  });

  final String label;
  final String value;
  final Color subtleColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTypography.caption.copyWith(color: subtleColor),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
