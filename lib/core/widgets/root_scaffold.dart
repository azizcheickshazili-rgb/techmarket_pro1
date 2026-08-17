import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Hosts the bottom navigation shared by the products, favorites and
/// profile tabs (`ShellRoute` keeps their state alive between switches).
class RootScaffold extends StatelessWidget {
  const RootScaffold({required this.child, super.key});

  final Widget child;

  static const List<String> _tabPaths = <String>[
    '/products',
    '/favorites',
    '/profile',
  ];

  int _indexForLocation(String location) {
    if (location.startsWith('/favorites')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    final int currentIndex = _indexForLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Semantics(
        container: true,
        label: 'Navigation principale',
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (int index) {
            if (index != currentIndex) context.go(_tabPaths[index]);
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront_rounded),
              label: 'Produits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: 'Favoris',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
