import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techmarket/app.dart';
import 'package:techmarket/core/providers/core_providers.dart';

/// End-to-end smoke test: boots the real app (against the live DummyJSON
/// API) and walks through splash -> login -> product list -> product
/// detail -> favorite toggle -> logout back to the login screen.
///
/// Requires network access on the test device/emulator, which is why it
/// lives in `integration_test/` and runs via `flutter test integration_test`
/// rather than the default `flutter test` unit/widget run.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login, browse a product, favorite it, then log out', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const TechMarketApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Splash should have redirected to the login screen.
    expect(find.byKey(const Key('login_username_field')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('login_username_field')), 'emilys');
    await tester.enterText(find.byKey(const Key('login_password_field')), 'emilyspass');
    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Product grid should now be visible.
    expect(find.byKey(const Key('product_grid')), findsOneWidget);

    // Favorite the first product card.
    final Finder firstFavoriteButton = find.byIcon(Icons.favorite_border_rounded).first;
    await tester.tap(firstFavoriteButton);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_rounded), findsWidgets);

    // Navigate to profile and log out.
    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('logout_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login_username_field')), findsOneWidget);
  });
}
