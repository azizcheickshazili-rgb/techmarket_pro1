import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techmarket_pro1/app.dart';
import 'package:techmarket_pro1/core/providers/core_providers.dart';

/// Root-level smoke test: the app boots to the splash screen without
/// throwing. This file's only real purpose is to occupy
/// `test/widget_test.dart` — without it, `flutter create --platforms=android .`
/// (run in CI to regenerate the native android/ folder) scaffolds its own
/// default counter-app test referencing a `MyApp` class that doesn't
/// exist in this project, which breaks `flutter analyze`.
void main() {
  testWidgets('App boots and renders the splash screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // The splash screen immediately reads from secure storage to restore
    // any saved session — stub the platform channel so that happens
    // against an in-memory store instead of a real (unavailable in
    // tests) keychain/keystore.
    const MethodChannel secureStorageChannel = MethodChannel(
      'plugins.it_nomads.com/flutter_secure_storage',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, (MethodCall call) async {
      if (call.method == 'read') return null;
      if (call.method == 'readAll') return <String, String>{};
      return null;
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const TechMarketApp(),
      ),
    );
    await tester.pump();

    expect(find.text('TechMarket'), findsOneWidget);
  });
}
