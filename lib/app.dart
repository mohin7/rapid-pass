import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/providers/app_providers.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// App root widget. Manages theme from Riverpod settings.
class RapidPassApp extends ConsumerWidget {
  const RapidPassApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final prefsAsync = ref.watch(sharedPreferencesProvider);

    // Wait for SharedPreferences before showing app
    return prefsAsync.when(
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Failed to initialize app')),
        ),
      ),
      data: (_) => _AppWithSettings(router: router),
    );
  }
}

class _AppWithSettings extends ConsumerWidget {
  const _AppWithSettings({required this.router});
  final GoRouter router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(safeSettingsProvider);

    final themeMode = switch (settings.themeMode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };

    return MaterialApp.router(
      title: 'Rapid Pass BD',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(settings.locale),
      builder: (context, child) {
        // Apply system UI overlay style based on theme
        final isDark = Theme.of(context).brightness == Brightness.dark;
        SystemChrome.setSystemUIOverlayStyle(
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        );
        return child!;
      },
    );
  }
}
