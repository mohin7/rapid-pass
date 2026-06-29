import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/providers/app_providers.dart';
import '../common/widgets/info_widgets.dart';

/// Statistics screen with charts and aggregated travel data.
class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statisticsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: stats == null
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bar_chart_rounded, size: 48, color: AppColors.primary),
                  SizedBox(height: AppSpacing.lg),
                  Text('Scan a card to view statistics'),
                ],
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  _buildOverviewGrid(context, stats),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildSpendingSection(context, stats),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildInsightCards(context, stats),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildOverviewGrid(BuildContext context, stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Overview'),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          childAspectRatio: 1.4,
          children: [
            StatCard(
              label: 'Total Trips',
              value: stats.totalTrips.toString(),
              icon: Icons.train_rounded,
              color: AppColors.primary,
              subtitle: '+${stats.thisMonthTrips} this month',
            ).animate().fadeIn(delay: 0.ms).slideY(begin: 0.1, end: 0),
            StatCard(
              label: 'Total Spent',
              value: '৳${stats.totalSpent.toStringAsFixed(0)}',
              icon: Icons.account_balance_wallet_rounded,
              color: AppColors.secondary,
              subtitle: '৳${stats.monthlySpending.toStringAsFixed(0)} this month',
            ).animate().fadeIn(delay: 80.ms).slideY(begin: 0.1, end: 0),
            StatCard(
              label: 'Total Distance',
              value: '${stats.totalDistance.toStringAsFixed(1)} km',
              icon: Icons.route_rounded,
              color: AppColors.info,
            ).animate().fadeIn(delay: 120.ms).slideY(begin: 0.1, end: 0),
            StatCard(
              label: 'Average Fare',
              value: '৳${stats.averageFare.toStringAsFixed(0)}',
              icon: Icons.payments_rounded,
              color: AppColors.warning,
            ).animate().fadeIn(delay: 160.ms).slideY(begin: 0.1, end: 0),
          ],
        ),
      ],
    );
  }

  Widget _buildSpendingSection(BuildContext context, stats) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Spending'),
        const SizedBox(height: AppSpacing.md),
        Container(
          height: 180,
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (stats.monthlySpending * 1.3).clamp(100, double.infinity),
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const titles = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                      return Text(
                        titles[value.toInt() % 7],
                        style: AppTypography.overline.copyWith(
                          color: isDark
                              ? AppColors.onSurfaceVariantDark
                              : AppColors.onSurfaceVariantLight,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '৳${value.toInt()}',
                        style: AppTypography.overline.copyWith(
                          color: isDark
                              ? AppColors.onSurfaceVariantDark
                              : AppColors.onSurfaceVariantLight,
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: (isDark ? AppColors.borderDark : AppColors.borderLight)
                      .withOpacity(0.5),
                  strokeWidth: 1,
                ),
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                _barGroup(0, 40, isDark),
                _barGroup(1, 80, isDark),
                _barGroup(2, 60, isDark),
                _barGroup(3, 100, isDark),
                _barGroup(4, 40, isDark),
                _barGroup(5, 20, isDark),
                _barGroup(6, 60, isDark),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _SpendSummaryTile(
                label: 'This Week',
                amount: stats.weeklySpending,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _SpendSummaryTile(
                label: 'This Month',
                amount: stats.monthlySpending,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  BarChartGroupData _barGroup(int x, double y, bool isDark) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primary,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildInsightCards(BuildContext context, stats) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Insights'),
        const SizedBox(height: AppSpacing.md),
        _InsightCard(
          icon: Icons.star_rounded,
          title: 'Most Visited Station',
          value: stats.mostVisitedStation,
          color: AppColors.warning,
          isDark: isDark,
        ).animate().fadeIn(delay: 100.ms),
        const SizedBox(height: AppSpacing.sm),
        _InsightCard(
          icon: Icons.trending_up_rounded,
          title: 'Longest Journey',
          value: '${stats.longestJourney.toStringAsFixed(1)} km',
          color: AppColors.success,
          isDark: isDark,
        ).animate().fadeIn(delay: 150.ms),
        const SizedBox(height: AppSpacing.sm),
        _InsightCard(
          icon: Icons.trending_down_rounded,
          title: 'Shortest Journey',
          value: '${stats.shortestJourney.toStringAsFixed(1)} km',
          color: AppColors.info,
          isDark: isDark,
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }
}

class _SpendSummaryTile extends StatelessWidget {
  const _SpendSummaryTile({
    required this.label,
    required this.amount,
    required this.isDark,
  });

  final String label;
  final double amount;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: isDark
                  ? AppColors.onSurfaceVariantDark
                  : AppColors.onSurfaceVariantLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '৳${amount.toStringAsFixed(0)}',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.isDark,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.caption.copyWith(
                    color: isDark
                        ? AppColors.onSurfaceVariantDark
                        : AppColors.onSurfaceVariantLight,
                  ),
                ),
                Text(value, style: AppTypography.titleSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
