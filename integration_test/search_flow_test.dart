import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techmarket_pro1/app.dart';
import 'package:techmarket_pro1/core/providers/core_providers.dart';

/// Second end-to-end scenario: after logging in, typing into the search
/// bar should replace the paginated grid with live search results from
/// `/products/search`.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('searching for a product filters the visible results', (
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

    await tester.enterText(find.byKey(const Key('login_username_field')), 'emilys');
    await tester.enterText(find.byKey(const Key('login_password_field')), 'emilyspass');
    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byKey(const Key('product_grid')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('product_search_field')), 'phone');
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // The paginated grid is replaced by search results — searching for
    // "phone" against DummyJSON always returns at least one product.
    expect(find.byKey(const Key('product_grid')), findsNothing);
    expect(find.textContaining('\$'), findsWidgets);
  });
}
