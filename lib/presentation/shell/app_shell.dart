import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/extensions/context_extensions.dart';

/// Shell scaffold that wraps all tab screens with the bottom navigation bar.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

class _AppBottomNav extends StatelessWidget {
  const _AppBottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home_rounded),
          label: context.l10n.tabHome,
        ),
        NavigationDestination(
          icon: const Icon(Icons.history_outlined),
          selectedIcon: const Icon(Icons.history_rounded),
          label: context.l10n.tabHistory,
        ),
        NavigationDestination(
          icon: const Icon(Icons.calculate_outlined),
          selectedIcon: const Icon(Icons.calculate_rounded),
          label: context.l10n.tabFare,
        ),
        NavigationDestination(
          icon: const Icon(Icons.map_outlined),
          selectedIcon: const Icon(Icons.map_rounded),
          label: context.l10n.tabMap,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings_rounded),
          label: context.l10n.tabSettings,
        ),
      ],
    );
  }
}
