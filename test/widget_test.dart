import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techmarket_pro1/app.dart';
import 'package:techmarket_pro1/core/providers/core_providers.dart';
import 'package:techmarket_pro1/features/auth/presentation/providers/auth_provider.dart';

/// A no-op auth controller: `restoreSession()` immediately settles to
/// "unauthenticated" without touching any real plugin, so this smoke
/// test never depends on flutter_secure_storage's platform channel
/// contract (which can vary across plugin versions).
class _FakeAuthController extends StateNotifier<AuthState> implements AuthController {
  _FakeAuthController() : super(const AuthInitial());

  @override
  Future<void> restoreSession() async {
    state = const AuthUnauthenticated();
  }

  @override
  Future<bool> login({required String username, required String password}) async {
    return false;
  }

  @override
  Future<void> logout() async {
    state = const AuthUnauthenticated();
  }
}

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

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          sharedPreferencesProvider.overrideWithValue(prefs),
          authControllerProvider.overrideWith((Ref ref) => _FakeAuthController()),
        ],
        child: const TechMarketApp(),
      ),
    );
    await tester.pump();
    // Allow the splash screen's redirect (splash -> login) to settle
    // without depending on exact timing.
    await tester.pump(const Duration(milliseconds: 100));

    // Whichever screen the router lands on, booting must not throw.
    expect(tester.takeException(), isNull);
  });
}
