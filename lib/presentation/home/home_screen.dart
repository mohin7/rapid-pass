import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_routes.dart';
import '../../core/services/nfc_service.dart';
import '../../domain/entities/rapid_pass_card.dart';
import '../../domain/entities/transaction.dart';
import '../../data/providers/app_providers.dart';
import '../common/widgets/balance_card.dart';
import '../common/widgets/info_widgets.dart';
import '../common/widgets/app_buttons.dart';
import '../common/widgets/trip_card.dart';

/// Home screen — the main landing screen showing balance and recent trips.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardState = ref.watch(cardStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context, isDark),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageHorizontal,
              ),
              child: switch (cardState) {
                CardStateInitial() => _buildNoCard(context, ref),
                CardStateScanning() => _buildScanning(context),
                CardStateLoaded(:final card, :final transactions) =>
                  _buildLoaded(context, ref, card, transactions),
                CardStateError(:final type) => _buildError(context, ref, type),
              },
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: 0,
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.train_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rapid Pass BD',
                style: AppTypography.titleSmall.copyWith(
                  color: isDark
                      ? AppColors.onSurfaceDark
                      : AppColors.onSurfaceLight,
                ),
              ),
              Text(
                'Dhaka Metro',
                style: AppTypography.overline.copyWith(
                  color: isDark
                      ? AppColors.onSurfaceVariantDark
                      : AppColors.onSurfaceVariantLight,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () {},
          tooltip: 'Search',
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
          tooltip: 'Notifications',
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }

  Widget _buildNoCard(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xl),
        _DemoBanner(),
        const SizedBox(height: AppSpacing.xxl),
        _NoCardHero(onScan: () => context.push(AppRoutes.nfcScan)),
        const SizedBox(height: AppSpacing.xxl),
        _QuickActions(onScan: () => context.push(AppRoutes.nfcScan)),
      ],
    );
  }

  Widget _buildScanning(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(48),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    WidgetRef ref,
    RapidPassCard card,
    List<CardTransaction> transactions,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final journeys = transactions.where((t) => t.isJourney).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        if (card.isDemo) _DemoBanner(),
        if (card.isDemo) const SizedBox(height: AppSpacing.lg),
        BalanceCard(
          card: card,
          onTap: () {},
        ),
        const SizedBox(height: AppSpacing.xxl),
        _CardQuickInfo(card: card),
        const SizedBox(height: AppSpacing.xxl),
        SectionHeader(
          title: 'Recent Trips',
          actionLabel: journeys.length > 3 ? 'See All' : null,
          onAction: () => context.go(AppRoutes.history),
        ),
        const SizedBox(height: AppSpacing.md),
        if (journeys.isEmpty)
          const EmptyState(
            icon: Icons.train_outlined,
            title: 'No trips yet',
            subtitle: 'Your trip history will appear here.',
          )
        else
          ...journeys.take(3).toList().asMap().entries.map((e) => Padding(
                padding: EdgeInsets.only(
                    bottom: e.key < 2 ? AppSpacing.sm : 0),
                child: TripCard(
                  transaction: e.value,
                  animationIndex: e.key,
                ),
              )),
        const SizedBox(height: AppSpacing.xxl),
        _StatsRow(
          totalTrips: card.totalTrips,
          totalSpent: card.totalSpent,
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, NfcErrorType type) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: EmptyState(
        icon: Icons.error_outline_rounded,
        title: 'Scan Failed',
        subtitle: 'Could not read your card. Please try again.',
        action: PrimaryButton(
          label: 'Scan Again',
          onPressed: () => context.push(AppRoutes.nfcScan),
        ),
      ),
    );
  }
}

class _DemoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: AppColors.warning),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Demo Mode — Sample data for demonstration',
              style: AppTypography.caption.copyWith(color: AppColors.warning),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _NoCardHero extends StatelessWidget {
  const _NoCardHero({required this.onScan});
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.nfc_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'Scan Your Rapid Pass',
            style: AppTypography.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Hold your Dhaka Metro card near the top\nof your phone to view your balance.',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.onSurfaceVariantDark
                  : AppColors.onSurfaceVariantLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          PrimaryButton(
            label: 'Scan Card',
            icon: Icons.nfc_rounded,
            onPressed: onScan,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0);
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onScan});
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Quick Actions'),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _QuickActionTile(
                icon: Icons.nfc_rounded,
                label: 'Scan Card',
                color: AppColors.primary,
                onTap: onScan,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _QuickActionTile(
                icon: Icons.calculate_rounded,
                label: 'Fare Calc',
                color: AppColors.info,
                onTap: () => context.go(AppRoutes.fareCalculator),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _QuickActionTile(
                icon: Icons.map_rounded,
                label: 'Metro Map',
                color: AppColors.success,
                onTap: () => context.go(AppRoutes.metroMap),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: AppTypography.labelSmall,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardQuickInfo extends StatelessWidget {
  const _CardQuickInfo({required this.card});
  final RapidPassCard card;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formatter = DateFormat('MMM dd, HH:mm');
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: [
          InfoRow(
            label: 'Card Number',
            value: card.cardNumber,
            icon: Icons.credit_card_rounded,
          ),
          InfoRow(
            label: 'Last Recharge',
            value: '৳${card.lastRechargeAmount.toStringAsFixed(0)} · ${formatter.format(card.lastRechargeDate)}',
            icon: Icons.add_card_rounded,
          ),
          InfoRow(
            label: 'Last Scan',
            value: formatter.format(card.lastScanTime),
            icon: Icons.nfc_rounded,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.totalTrips, required this.totalSpent});
  final int totalTrips;
  final double totalSpent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'Total Trips',
            value: totalTrips.toString(),
            icon: Icons.train_rounded,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: StatCard(
            label: 'Total Spent',
            value: '৳${totalSpent.toStringAsFixed(0)}',
            icon: Icons.account_balance_wallet_rounded,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}
