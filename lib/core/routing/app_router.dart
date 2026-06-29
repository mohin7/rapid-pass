import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_routes.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/history/history_screen.dart';
import '../../presentation/history/trip_detail_screen.dart';
import '../../presentation/fare_calculator/fare_calculator_screen.dart';
import '../../presentation/metro_map/metro_map_screen.dart';
import '../../presentation/settings/settings_screen.dart';
import '../../presentation/nfc_scan/nfc_scan_screen.dart';
import '../../presentation/statistics/statistics_screen.dart';
import '../../presentation/shell/app_shell.dart';

/// Riverpod provider for the GoRouter instance.
final routerProvider = Provider<GoRouter>((ref) => _buildRouter());

GoRouter _buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,
    routes: [
      // ── Shell route with bottom navigation ─────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                pageBuilder: (context, state) => _fadePage(
                  state: state,
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                name: 'history',
                pageBuilder: (context, state) => _fadePage(
                  state: state,
                  child: const HistoryScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'trip/:id',
                    name: 'tripDetail',
                    pageBuilder: (context, state) => _slidePage(
                      state: state,
                      child: TripDetailScreen(
                        tripId: state.pathParameters['id'] ?? '',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.fareCalculator,
                name: 'fareCalculator',
                pageBuilder: (context, state) => _fadePage(
                  state: state,
                  child: const FareCalculatorScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.metroMap,
                name: 'metroMap',
                pageBuilder: (context, state) => _fadePage(
                  state: state,
                  child: const MetroMapScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: 'settings',
                pageBuilder: (context, state) => _fadePage(
                  state: state,
                  child: const SettingsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      // ── Full-screen routes (no shell) ─────────────────────────────────────
      GoRoute(
        path: AppRoutes.nfcScan,
        name: 'nfcScan',
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const NfcScanScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.statistics,
        name: 'statistics',
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const StatisticsScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.error}'),
      ),
    ),
  );
}

// ── Page transition helpers ───────────────────────────────────────────────────

CustomTransitionPage<void> _fadePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}

CustomTransitionPage<void> _slidePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurveTween(curve: Curves.easeOutCubic).animate(animation)),
        child: child,
      );
    },
  );
}
