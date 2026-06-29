import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/providers/app_providers.dart';
import '../../domain/entities/transaction.dart';
import '../common/widgets/trip_card.dart';
import '../common/widgets/info_widgets.dart';
import '../common/widgets/app_buttons.dart';
import '../../core/constants/app_routes.dart';

/// Trip history screen with date-grouped timeline.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _filter = 'all'; // 'all', 'journey', 'recharge'
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final cardState = ref.watch(cardStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
                CardStateLoaded(:final transactions) =>
                  _buildHistory(context, transactions),
                _ => _buildEmpty(context),
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
      title: const Text('History'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageHorizontal,
                vertical: AppSpacing.sm,
              ),
              child: TextField(
                onChanged: (q) => setState(() => _searchQuery = q),
                decoration: InputDecoration(
                  hintText: 'Search stations...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                ),
              ),
            ),
            // Filter chips
            SizedBox(
              height: 44,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _filter == 'all',
                    onTap: () => setState(() => _filter = 'all'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _FilterChip(
                    label: 'Journeys',
                    isSelected: _filter == 'journey',
                    onTap: () => setState(() => _filter = 'journey'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _FilterChip(
                    label: 'Recharges',
                    isSelected: _filter == 'recharge',
                    onTap: () => setState(() => _filter = 'recharge'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory(BuildContext context, List<CardTransaction> transactions) {
    // Filter
    var filtered = transactions.where((t) {
      if (_filter == 'journey') return t.isJourney;
      if (_filter == 'recharge') return t.isRecharge;
      return true;
    }).toList();

    // Search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered
          .where((t) =>
              t.entryStation.toLowerCase().contains(q) ||
              (t.exitStation?.toLowerCase().contains(q) ?? false))
          .toList();
    }

    if (filtered.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 60),
        child: EmptyState(
          icon: Icons.history_rounded,
          title: 'No trips found',
          subtitle: 'Try adjusting your search or filter.',
        ),
      );
    }

    // Group by date
    final grouped = <String, List<CardTransaction>>{};
    for (final tx in filtered) {
      final key = _dateKey(tx.entryTime);
      grouped.putIfAbsent(key, () => []).add(tx);
    }

    int globalIndex = 0;
    return Column(
      children: [
        const SizedBox(height: AppSpacing.md),
        ...grouped.entries.map((entry) {
          final items = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DateHeader(label: entry.key),
              const SizedBox(height: AppSpacing.sm),
              ...items.map((tx) {
                final idx = globalIndex++;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: TripCard(
                    transaction: tx,
                    animationIndex: idx,
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.md),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: EmptyState(
        icon: Icons.history_rounded,
        title: 'No Trip History',
        subtitle: 'Scan your Rapid Pass card to see your trip history.',
        action: PrimaryButton(
          label: 'Scan Card',
          onPressed: () => context.push(AppRoutes.nfcScan),
        ),
      ),
    );
  }

  String _dateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);

    if (d == today) return 'Today';
    if (d == yesterday) return 'Yesterday';
    return DateFormat('MMMM dd, yyyy').format(date);
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      label,
      style: AppTypography.titleSmall.copyWith(
        color: isDark
            ? AppColors.onSurfaceVariantDark
            : AppColors.onSurfaceVariantLight,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark
                  ? AppColors.surfaceVariantDark
                  : AppColors.surfaceVariantLight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected
                ? Colors.white
                : (isDark
                    ? AppColors.onSurfaceVariantDark
                    : AppColors.onSurfaceVariantLight),
          ),
        ),
      ),
    );
  }
}

/// Trip detail receipt screen.
class TripDetailScreen extends ConsumerWidget {
  const TripDetailScreen({super.key, required this.tripId});
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardState = ref.watch(cardStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final transaction = cardState is CardStateLoaded
        ? cardState.transactions.where((t) => t.id == tripId).firstOrNull
        : null;

    if (transaction == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trip Detail')),
        body: const EmptyState(
          icon: Icons.receipt_long_rounded,
          title: 'Trip not found',
        ),
      );
    }

    final timeFormatter = DateFormat('EEEE, MMMM dd • HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text('Trip Detail')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        child: Column(
          children: [
            // Receipt header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                gradient: transaction.isRecharge
                    ? LinearGradient(
                        colors: [
                          AppColors.success.withOpacity(0.9),
                          AppColors.success.withOpacity(0.7)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : AppColors.cardGradient,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
              ),
              child: Column(
                children: [
                  Icon(
                    transaction.isRecharge
                        ? Icons.add_card_rounded
                        : Icons.train_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    transaction.isRecharge ? 'Recharge' : 'Journey',
                    style: AppTypography.overline.copyWith(
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 2,
                    ),
                  ),
                  if (!transaction.isRecharge) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${transaction.entryStation} → ${transaction.exitStation}',
                      style: AppTypography.titleMedium
                          .copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    transaction.isRecharge
                        ? '+৳${transaction.rechargeAmount?.toStringAsFixed(2)}'
                        : '-৳${transaction.fare.toStringAsFixed(2)}',
                    style: AppTypography.balanceMedium
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    timeFormatter.format(transaction.entryTime),
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.05, end: 0),
            const SizedBox(height: AppSpacing.xxl),
            // Details
            InfoCard(
              title: 'Details',
              children: [
                if (!transaction.isRecharge) ...[
                  InfoRow(
                    label: 'Entry Station',
                    value: transaction.entryStation,
                    icon: Icons.login_rounded,
                  ),
                  if (transaction.exitStation != null)
                    InfoRow(
                      label: 'Exit Station',
                      value: transaction.exitStation!,
                      icon: Icons.logout_rounded,
                    ),
                  if (transaction.exitTime != null)
                    InfoRow(
                      label: 'Arrival',
                      value: timeFormatter.format(transaction.exitTime!),
                      icon: Icons.schedule_rounded,
                    ),
                  InfoRow(
                    label: 'Duration',
                    value: '${transaction.duration} minutes',
                    icon: Icons.timer_rounded,
                  ),
                  InfoRow(
                    label: 'Distance',
                    value: '${transaction.distance.toStringAsFixed(1)} km',
                    icon: Icons.route_rounded,
                  ),
                  InfoRow(
                    label: 'Fare',
                    value: '৳${transaction.fare.toStringAsFixed(2)}',
                    icon: Icons.payments_rounded,
                  ),
                ],
                InfoRow(
                  label: 'Balance Before',
                  value: '৳${transaction.balanceBefore.toStringAsFixed(2)}',
                  icon: Icons.account_balance_wallet_outlined,
                ),
                InfoRow(
                  label: 'Balance After',
                  value: '৳${transaction.balanceAfter.toStringAsFixed(2)}',
                  icon: Icons.account_balance_wallet_rounded,
                  valueColor: transaction.isRecharge
                      ? AppColors.success
                      : AppColors.primary,
                  isLast: true,
                ),
              ],
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: AppSpacing.lg),
            InfoCard(
              title: 'Transaction Info',
              children: [
                InfoRow(
                  label: 'Transaction ID',
                  value: transaction.id,
                  icon: Icons.tag_rounded,
                ),
                InfoRow(
                  label: 'Type',
                  value: transaction.isRecharge ? 'Recharge' : 'Journey',
                  icon: Icons.category_rounded,
                  isLast: true,
                ),
              ],
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
