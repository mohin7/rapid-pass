import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/datasources/local/station_data.dart';
import '../../domain/entities/station.dart';

/// Interactive metro map screen with custom painted MRT Line 6.
class MetroMapScreen extends ConsumerStatefulWidget {
  const MetroMapScreen({super.key});

  @override
  ConsumerState<MetroMapScreen> createState() => _MetroMapScreenState();
}

class _MetroMapScreenState extends ConsumerState<MetroMapScreen> {
  String _searchQuery = '';
  MetroStation? _selectedStation;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stations = _searchQuery.isEmpty
        ? StationData.allStations
        : StationData.searchByName(_searchQuery);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text('Metro Map'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                  vertical: AppSpacing.sm,
                ),
                child: TextField(
                  onChanged: (q) => setState(() => _searchQuery = q),
                  decoration: InputDecoration(
                    hintText: 'Search station...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () =>
                                setState(() => _searchQuery = ''),
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Metro Map
                if (_searchQuery.isEmpty)
                  _MetroMapCanvas(
                    selectedStation: _selectedStation,
                    onStationTap: (s) =>
                        setState(() => _selectedStation = s),
                    transformationController: _transformationController,
                  ),
                // Station list (or search results)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pageHorizontal,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_searchQuery.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          '${stations.length} station${stations.length != 1 ? 's' : ''} found',
                          style: AppTypography.caption.copyWith(
                            color: isDark
                                ? AppColors.onSurfaceVariantDark
                                : AppColors.onSurfaceVariantLight,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ] else ...[
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          'MRT Line 6 Stations',
                          style: AppTypography.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      ...stations.asMap().entries.map((e) {
                        final station = e.value;
                        final isSelected =
                            _selectedStation?.code == station.code;
                        return _StationListTile(
                          station: station,
                          isSelected: isSelected,
                          animationIndex: e.key,
                          onTap: () {
                            setState(() => _selectedStation = station);
                            _showStationDetail(context, station);
                          },
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showStationDetail(BuildContext context, MetroStation station) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.cardRadiusLg),
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      station.code,
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(station.nameEn, style: AppTypography.titleLarge),
                    Text(
                      station.nameBn,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.onSurfaceVariantDark
                            : AppColors.onSurfaceVariantLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              children: [
                Expanded(
                  child: _StationDetailStat(
                    label: 'Line',
                    value: station.line.displayName,
                    icon: Icons.linear_scale_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _StationDetailStat(
                    label: 'Distance',
                    value: '${station.distanceFromStart.toStringAsFixed(1)} km',
                    icon: Icons.route_rounded,
                    color: AppColors.info,
                  ),
                ),
                if (station.isInterchange) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _StationDetailStat(
                      label: 'Type',
                      value: 'Interchange',
                      icon: Icons.sync_alt,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to fare calculator with this station selected
                },
                icon: const Icon(Icons.calculate_rounded, size: 18),
                label: const Text('Calculate Fare From Here'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetroMapCanvas extends StatelessWidget {
  const _MetroMapCanvas({
    required this.selectedStation,
    required this.onStationTap,
    required this.transformationController,
  });

  final MetroStation? selectedStation;
  final ValueChanged<MetroStation> onStationTap;
  final TransformationController transformationController;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stations = StationData.mrt6Stations;

    return Container(
      height: 260,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
        child: InteractiveViewer(
          transformationController: transformationController,
          minScale: 0.5,
          maxScale: 3.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Line label
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.xl,
                    bottom: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.mrt6,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'MRT Line 6',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.mrt6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Station dots + line
                SizedBox(
                  height: 120,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: CustomPaint(
                      size: Size(stations.length * 60.0, 120),
                      painter: _MetroLinePainter(
                        stations: stations,
                        selectedStation: selectedStation,
                        isDark: isDark,
                      ),
                      child: SizedBox(
                        width: stations.length * 60.0,
                        height: 120,
                        child: Stack(
                          children: stations.asMap().entries.map((e) {
                            final i = e.key;
                            final s = e.value;
                            final isSelected = selectedStation?.code == s.code;
                            return Positioned(
                              left: i * 60.0,
                              top: 0,
                              width: 60,
                              height: 120,
                              child: GestureDetector(
                                onTap: () => onStationTap(s),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Station name (top)
                                    SizedBox(
                                      height: 36,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: Text(
                                          s.nameEn.split(' ').first,
                                          style: AppTypography.overline.copyWith(
                                            color: isSelected
                                                ? AppColors.primary
                                                : (isDark
                                                    ? AppColors
                                                        .onSurfaceVariantDark
                                                    : AppColors
                                                        .onSurfaceVariantLight),
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    // Dot
                                    Container(
                                      width: isSelected ? 16 : 10,
                                      height: isSelected ? 16 : 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: s.isInterchange
                                            ? AppColors.secondary
                                            : (isSelected
                                                ? AppColors.primary
                                                : Colors.white),
                                        border: Border.all(
                                          color: s.isInterchange
                                              ? AppColors.secondary
                                              : AppColors.primary,
                                          width: 2.5,
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: AppColors.primary
                                                      .withOpacity(0.4),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                )
                                              ]
                                            : null,
                                      ),
                                    ),
                                    // Code (bottom)
                                    const SizedBox(height: 4),
                                    Text(
                                      s.code,
                                      style: AppTypography.overline.copyWith(
                                        color: isSelected
                                            ? AppColors.primary
                                            : (isDark
                                                ? AppColors.onSurfaceVariantDark
                                                : AppColors
                                                    .onSurfaceVariantLight),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '↑ Uttara North',
                        style: AppTypography.caption.copyWith(
                          color: isDark
                              ? AppColors.onSurfaceVariantDark
                              : AppColors.onSurfaceVariantLight,
                        ),
                      ),
                      Text(
                        'Kamalapur ↓',
                        style: AppTypography.caption.copyWith(
                          color: isDark
                              ? AppColors.onSurfaceVariantDark
                              : AppColors.onSurfaceVariantLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _MetroLinePainter extends CustomPainter {
  _MetroLinePainter({
    required this.stations,
    required this.selectedStation,
    required this.isDark,
  });

  final List<MetroStation> stations;
  final MetroStation? selectedStation;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Draw the line connecting all station dots
    for (int i = 0; i < stations.length - 1; i++) {
      final x1 = i * 60.0 + 30;
      final x2 = (i + 1) * 60.0 + 30;
      final y = size.height / 2;
      canvas.drawLine(Offset(x1, y), Offset(x2, y), paint);
    }
  }

  @override
  bool shouldRepaint(_MetroLinePainter oldDelegate) =>
      oldDelegate.selectedStation != selectedStation ||
      oldDelegate.isDark != isDark;
}

class _StationListTile extends StatelessWidget {
  const _StationListTile({
    required this.station,
    required this.isSelected,
    required this.animationIndex,
    required this.onTap,
  });

  final MetroStation station;
  final bool isSelected;
  final int animationIndex;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer
              : (isDark ? AppColors.cardDark : AppColors.cardLight),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withOpacity(0.4)
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  station.code,
                  style: AppTypography.labelSmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.nameEn,
                    style: AppTypography.titleSmall.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.onSurfaceDark
                              : AppColors.onSurfaceLight),
                    ),
                  ),
                  Text(
                    station.nameBn,
                    style: AppTypography.caption.copyWith(
                      color: isSelected
                          ? AppColors.primaryLight
                          : (isDark
                              ? AppColors.onSurfaceVariantDark
                              : AppColors.onSurfaceVariantLight),
                    ),
                  ),
                ],
              ),
            ),
            if (station.isInterchange)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Interchange',
                  style: AppTypography.overline.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '${station.distanceFromStart.toStringAsFixed(1)} km',
              style: AppTypography.caption.copyWith(
                color: isDark
                    ? AppColors.onSurfaceVariantDark
                    : AppColors.onSurfaceVariantLight,
              ),
            ),
          ],
        ),
      ),
    )
        .animate(
          delay: Duration(milliseconds: animationIndex * 40),
        )
        .fadeIn(duration: 250.ms)
        .slideX(begin: 0.05, end: 0);
  }
}

class _StationDetailStat extends StatelessWidget {
  const _StationDetailStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: AppTypography.overline.copyWith(
              color: isDark
                  ? AppColors.onSurfaceVariantDark
                  : AppColors.onSurfaceVariantLight,
            ),
          ),
        ],
      ),
    );
  }
}
