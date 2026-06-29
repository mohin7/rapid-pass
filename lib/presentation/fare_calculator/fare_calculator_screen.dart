import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/providers/app_providers.dart';
import '../../data/datasources/local/station_data.dart';
import '../../domain/entities/station.dart';

/// Fare calculator screen — select origin/destination, see estimated fare.
class FareCalculatorScreen extends ConsumerWidget {
  const FareCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fareState = ref.watch(fareCalculatorProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text('Fare Calculator'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  _StationSelector(
                    label: 'From',
                    icon: Icons.trip_origin_rounded,
                    iconColor: AppColors.primary,
                    selected: fareState.fromStation,
                    onSelect: (s) => ref
                        .read(fareCalculatorProvider.notifier)
                        .setFromStation(s),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Center(
                    child: GestureDetector(
                      onTap: () =>
                          ref.read(fareCalculatorProvider.notifier).swapStations(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surfaceVariantDark
                              : AppColors.surfaceVariantLight,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          ),
                        ),
                        child: const Icon(
                          Icons.swap_vert_rounded,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _StationSelector(
                    label: 'To',
                    icon: Icons.location_on_rounded,
                    iconColor: AppColors.secondary,
                    selected: fareState.toStation,
                    onSelect: (s) => ref
                        .read(fareCalculatorProvider.notifier)
                        .setToStation(s),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  if (fareState.fromStation != null &&
                      fareState.toStation != null &&
                      fareState.result == null)
                    _CalculateButton(
                      onTap: () =>
                          ref.read(fareCalculatorProvider.notifier).calculate(),
                    ),
                  if (fareState.result != null)
                    _FareResultCard(result: fareState.result!),
                  if (fareState.fromStation == null ||
                      fareState.toStation == null)
                    _SelectStationsHint(),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }
}

class _StationSelector extends ConsumerStatefulWidget {
  const _StationSelector({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.selected,
    required this.onSelect,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final MetroStation? selected;
  final ValueChanged<MetroStation> onSelect;

  @override
  ConsumerState<_StationSelector> createState() => _StationSelectorState();
}

class _StationSelectorState extends ConsumerState<_StationSelector> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = widget.selected != null;

    return GestureDetector(
      onTap: () => _showStationPicker(context),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: isSelected
                ? widget.iconColor.withOpacity(0.4)
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: widget.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 18),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: AppTypography.caption.copyWith(
                      color: isDark
                          ? AppColors.onSurfaceVariantDark
                          : AppColors.onSurfaceVariantLight,
                    ),
                  ),
                  Text(
                    widget.selected?.nameEn ?? 'Select station',
                    style: AppTypography.titleSmall.copyWith(
                      color: isSelected
                          ? (isDark
                              ? AppColors.onSurfaceDark
                              : AppColors.onSurfaceLight)
                          : (isDark
                              ? AppColors.onSurfaceVariantDark
                              : AppColors.onSurfaceVariantLight),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isDark
                  ? AppColors.onSurfaceVariantDark
                  : AppColors.onSurfaceVariantLight,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showStationPicker(BuildContext context) async {
    final result = await showModalBottomSheet<MetroStation>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _StationPickerSheet(
        title: widget.label,
        onSelect: (s) => Navigator.of(context).pop(s),
      ),
    );
    if (result != null) widget.onSelect(result);
  }
}

class _StationPickerSheet extends StatefulWidget {
  const _StationPickerSheet({required this.title, required this.onSelect});
  final String title;
  final ValueChanged<MetroStation> onSelect;

  @override
  State<_StationPickerSheet> createState() => _StationPickerSheetState();
}

class _StationPickerSheetState extends State<_StationPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stations = _query.isEmpty
        ? StationData.allStations
        : StationData.searchByName(_query);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.cardRadiusLg),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select ${widget.title} Station',
                      style: AppTypography.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      autofocus: true,
                      onChanged: (q) => setState(() => _query = q),
                      decoration: const InputDecoration(
                        hintText: 'Search station...',
                        prefixIcon: Icon(Icons.search_rounded, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: ListView.separated(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pageHorizontal,
                    vertical: AppSpacing.sm,
                  ),
                  itemCount: stations.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final station = stations[i];
                    return ListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            station.code,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      title: Text(station.nameEn,
                          style: AppTypography.bodyMedium),
                      subtitle: Text(
                        station.nameBn,
                        style: AppTypography.caption.copyWith(
                          color: isDark
                              ? AppColors.onSurfaceVariantDark
                              : AppColors.onSurfaceVariantLight,
                        ),
                      ),
                      trailing: station.isInterchange
                          ? const Icon(Icons.sync_alt,
                              size: 16, color: AppColors.secondary)
                          : null,
                      onTap: () => widget.onSelect(station),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CalculateButton extends StatelessWidget {
  const _CalculateButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.calculate_rounded),
        label: const Text('Calculate Fare'),
      ),
    );
  }
}

class _SelectStationsHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxxl),
          Icon(
            Icons.route_rounded,
            size: 48,
            color: isDark
                ? AppColors.onSurfaceVariantDark
                : AppColors.onSurfaceVariantLight,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Select both stations\nto calculate fare',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.onSurfaceVariantDark
                  : AppColors.onSurfaceVariantLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FareResultCard extends StatelessWidget {
  const _FareResultCard({required this.result});
  final FareResult result;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fare highlight
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xxl),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Estimated Fare',
                style: AppTypography.caption.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '৳',
                      style: AppTypography.currencySymbol
                          .copyWith(color: Colors.white.withOpacity(0.9)),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    result.fare.toStringAsFixed(0),
                    style: AppTypography.balanceLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _FareStat(
                    label: 'Distance',
                    value: '${result.distance.toStringAsFixed(1)} km',
                  ),
                  Container(width: 1, height: 30, color: Colors.white24),
                  _FareStat(
                    label: 'Time',
                    value: '~${result.estimatedMinutes} min',
                  ),
                  Container(width: 1, height: 30, color: Colors.white24),
                  _FareStat(
                    label: 'Stations',
                    value: result.stationsCount.toString(),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
        const SizedBox(height: AppSpacing.xxl),
        // Route summary
        Text('Route', style: AppTypography.titleSmall.copyWith(
          color: isDark
              ? AppColors.onSurfaceVariantDark
              : AppColors.onSurfaceVariantLight,
        )),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            children: result.route.asMap().entries.map<Widget>((e) {
              final isFirst = e.key == 0;
              final isLast = e.key == result.route.length - 1;
              final station = e.value;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    child: Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isFirst || isLast
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.4),
                            border: Border.all(
                              color: AppColors.primary,
                              width: isFirst || isLast ? 0 : 1.5,
                            ),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 24,
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Text(
                        station.nameEn,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight:
                              (isFirst || isLast) ? FontWeight.w600 : FontWeight.w400,
                          color: (isFirst || isLast)
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.onSurfaceDark
                                  : AppColors.onSurfaceLight),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ).animate().fadeIn(delay: 150.ms),
      ],
    );
  }
}

class _FareStat extends StatelessWidget {
  const _FareStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style:
              AppTypography.titleSmall.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}


