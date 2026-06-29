import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../data/providers/app_providers.dart';
import '../../core/extensions/context_extensions.dart';

/// Settings screen — theme, language, biometrics, about.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(safeSettingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(pinned: true, title: Text(context.l10n.settings)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  // Appearance
                  _SettingsSection(
                    title: context.l10n.appearance,
                    children: [
                      _ThemeTile(
                        currentMode: settings.themeMode,
                        onChanged: (mode) => ref
                            .read(settingsProvider.notifier)
                            .setThemeMode(mode),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // Language
                  _SettingsSection(
                    title: context.l10n.language,
                    children: [
                      _LanguageTile(
                        currentLocale: settings.locale,
                        onChanged: (locale) => ref
                            .read(settingsProvider.notifier)
                            .setLocale(locale),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // Security
                  _SettingsSection(
                    title: context.l10n.security,
                    children: [
                      _SwitchTile(
                        icon: Icons.face_rounded,
                        label: context.l10n.faceId,
                        subtitle: 'Use biometrics to unlock the app',
                        value: settings.biometricsEnabled,
                        onChanged: (v) => ref
                            .read(settingsProvider.notifier)
                            .setBiometrics(v),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // About
                  _SettingsSection(
                    title: context.l10n.about,
                    children: [
                      _NavTile(
                        icon: Icons.info_outline_rounded,
                        label: '${context.l10n.about} ${context.l10n.appName}',
                        onTap: () => _showAbout(context),
                      ),
                      _NavTile(
                        icon: Icons.help_outline_rounded,
                        label: context.l10n.help,
                        onTap: () => _showHelp(context),
                      ),
                      _NavTile(
                        icon: Icons.feedback_outlined,
                        label: context.l10n.feedback,
                        onTap: () => _showFeedback(context),
                      ),
                      _NavTile(
                        icon: Icons.privacy_tip_outlined,
                        label: context.l10n.privacy,
                        onTap: () => _showPrivacy(context),
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // Version info
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.train_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          context.l10n.appName,
                          style: AppTypography.titleSmall,
                        ),
                        Text(
                          '${context.l10n.version} ${AppConstants.appVersion}',
                          style: AppTypography.caption.copyWith(
                            color: isDark
                                ? AppColors.onSurfaceVariantDark
                                : AppColors.onSurfaceVariantLight,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '⚠️ Demo Mode Active — NFC reads use mock data',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.warning,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _AboutSheet(),
    );
  }

  void _showHelp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _HelpSheet(),
    );
  }

  void _showFeedback(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const _FeedbackDialog(),
    );
  }

  void _showPrivacy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PrivacySheet(),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.sm),
          child: Text(
            title.toUpperCase(),
            style: AppTypography.overline.copyWith(
              color: isDark
                  ? AppColors.onSurfaceVariantDark
                  : AppColors.onSurfaceVariantLight,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Column(children: children),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0);
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({required this.currentMode, required this.onChanged});
  final AppThemeMode currentMode;
  final ValueChanged<AppThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette_outlined,
                  size: 20,
                  color: isDark
                      ? AppColors.onSurfaceVariantDark
                      : AppColors.onSurfaceVariantLight),
              const SizedBox(width: AppSpacing.md),
              Text(context.l10n.appearance, style: AppTypography.bodyMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _ThemeOption(
                  label: context.l10n.themeLight,
                  icon: Icons.light_mode_rounded,
                  isSelected: currentMode == AppThemeMode.light,
                  onTap: () => onChanged(AppThemeMode.light),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ThemeOption(
                  label: context.l10n.themeDark,
                  icon: Icons.dark_mode_rounded,
                  isSelected: currentMode == AppThemeMode.dark,
                  onTap: () => onChanged(AppThemeMode.dark),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ThemeOption(
                  label: context.l10n.themeSystem,
                  icon: Icons.phone_android_rounded,
                  isSelected: currentMode == AppThemeMode.system,
                  onTap: () => onChanged(AppThemeMode.system),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer
              : (isDark
                  ? AppColors.surfaceVariantDark
                  : AppColors.surfaceVariantLight),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withOpacity(0.5)
                : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? AppColors.primary
                  : (isDark
                      ? AppColors.onSurfaceVariantDark
                      : AppColors.onSurfaceVariantLight),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                        ? AppColors.onSurfaceVariantDark
                        : AppColors.onSurfaceVariantLight),
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.currentLocale, required this.onChanged});
  final String currentLocale;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.language_rounded,
                  size: 20,
                  color: isDark
                      ? AppColors.onSurfaceVariantDark
                      : AppColors.onSurfaceVariantLight),
              const SizedBox(width: AppSpacing.md),
              Text(context.l10n.language, style: AppTypography.bodyMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _LanguageOption(
                  label: context.l10n.english,
                  code: 'en',
                  isSelected: currentLocale == 'en',
                  onTap: () => onChanged('en'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _LanguageOption(
                  label: context.l10n.bangla,
                  code: 'bn',
                  isSelected: currentLocale == 'bn',
                  onTap: () => onChanged('bn'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.code,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer
              : (isDark
                  ? AppColors.surfaceVariantDark
                  : AppColors.surfaceVariantLight),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withOpacity(0.5)
                : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: isSelected
                  ? AppColors.primary
                  : (isDark
                      ? AppColors.onSurfaceVariantDark
                      : AppColors.onSurfaceVariantLight),
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 20,
              color: isDark
                  ? AppColors.onSurfaceVariantDark
                  : AppColors.onSurfaceVariantLight),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.bodyMedium),
                Text(
                  subtitle,
                  style: AppTypography.caption.copyWith(
                    color: isDark
                        ? AppColors.onSurfaceVariantDark
                        : AppColors.onSurfaceVariantLight,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardPadding,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Icon(icon,
                    size: 20,
                    color: isDark
                        ? AppColors.onSurfaceVariantDark
                        : AppColors.onSurfaceVariantLight),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Text(label, style: AppTypography.bodyMedium)),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: isDark
                      ? AppColors.onSurfaceVariantDark
                      : AppColors.onSurfaceVariantLight,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xl + AppSpacing.md),
            child: Divider(
              height: 1,
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            ),
          ),
      ],
    );
  }
}

class _AboutSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadiusLg),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.train_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Rapid Pass BD', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Dhaka Metro Rapid Pass Balance & Trip History',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.onSurfaceVariantDark
                  : AppColors.onSurfaceVariantLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Version ${AppConstants.appVersion}',
            style: AppTypography.caption.copyWith(
              color: isDark
                  ? AppColors.onSurfaceVariantDark
                  : AppColors.onSurfaceVariantLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const _NfcDisclaimerCard(),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _NfcDisclaimerCard extends StatelessWidget {
  const _NfcDisclaimerCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: AppColors.warning),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'NFC Technical Notice',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'The Dhaka Metro Rapid Pass uses Sony FeliCa technology with proprietary DMTCL encryption keys. Real card data cannot be read without official API authorization. This app uses demonstration data only.',
            style: AppTypography.caption.copyWith(
              color: AppColors.warning.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
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
          Text(
            context.l10n.help,
            style: AppTypography.titleLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          _FaqItem(
            question: 'How do I recharge my Rapid Pass?',
            answer: 'You can recharge your card at any metro station ticket office or Ticket Vending Machine (TVM) using cash or mobile financial services (bKash, Nagad, etc.).',
            isDark: isDark,
          ),
          _FaqItem(
            question: 'Can I top up inside the app?',
            answer: 'Direct in-app top-up is currently not supported. You must recharge at a physical station ticket desk or TVM.',
            isDark: isDark,
          ),
          _FaqItem(
            question: 'What should I do if my card is lost?',
            answer: 'Please contact the DMTCL customer service desk at any metro station. They can issue a replacement and transfer your balance.',
            isDark: isDark,
            isLast: true,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({
    required this.question,
    required this.answer,
    required this.isDark,
    this.isLast = false,
  });

  final String question;
  final String answer;
  final bool isDark;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: AppTypography.titleSmall.copyWith(
              color: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackDialog extends StatefulWidget {
  const _FeedbackDialog();

  @override
  State<_FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<_FeedbackDialog> {
  final _controller = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      title: Text(context.l10n.feedback, style: AppTypography.titleLarge),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rate your experience:',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              return GestureDetector(
                onTap: () => setState(() => _rating = starIndex),
                child: Icon(
                  starIndex <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                  color: AppColors.warning,
                  size: 32,
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Share your thoughts or suggestions...',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Thank you for your feedback!'),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Text(context.l10n.done, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class _PrivacySheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
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
          Text(
            context.l10n.privacy,
            style: AppTypography.titleLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          _PrivacyItem(
            title: 'No Data Collection',
            description: 'We do not collect, store, or share any personal information, card numbers, or transaction logs.',
            isDark: isDark,
          ),
          _PrivacyItem(
            title: '100% Local Processing',
            description: 'All scanned card data is processed locally on your device and is never uploaded to any server.',
            isDark: isDark,
          ),
          _PrivacyItem(
            title: 'No Tracking',
            description: 'We do not use any third-party tracking, advertising, or analytics SDKs.',
            isDark: isDark,
            isLast: true,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _PrivacyItem extends StatelessWidget {
  const _PrivacyItem({
    required this.title,
    required this.description,
    required this.isDark,
    this.isLast = false,
  });

  final String title;
  final String description;
  final bool isDark;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security_rounded, size: 16, color: AppColors.success),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.titleSmall.copyWith(
                  color: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
            ),
          ),
        ],
      ),
    );
  }
}
