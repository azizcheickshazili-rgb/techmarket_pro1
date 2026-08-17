import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techmarket/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:techmarket/features/favorites/presentation/screens/favorites_screen.dart';

import '../test_harness.dart';

void main() {
  testWidgets('FavoritesScreen shows the empty state message when there are no favorites',
      (WidgetTester tester) async {
    await pumpLocalizedWidget(
      tester,
      child: const FavoritesScreen(),
      overrides: <Override>[
        favoritesControllerProvider.overrideWith(
          (Ref ref) => _EmptyFavoritesController(),
        ),
      ],
    );

    expect(find.text('Tu n\'as encore ajouté aucun favori.'), findsOneWidget);
  });
}

/// Minimal controller stub that stays empty and never touches storage —
/// keeps this test focused purely on the empty-state UI.
class _EmptyFavoritesController extends StateNotifier<Set<int>>
    implements FavoritesController {
  _EmptyFavoritesController() : super(const <int>{});

  @override
  bool isFavorite(int productId) => false;

  @override
  Future<void> toggle(int productId) async {}
}
