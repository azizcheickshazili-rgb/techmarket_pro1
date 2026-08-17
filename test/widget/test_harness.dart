import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techmarket/core/l10n/generated/app_localizations.dart';

/// Shared harness so every widget test wires localization and Riverpod
/// the same way instead of duplicating boilerplate per test file.
Future<void> pumpLocalizedWidget(
  WidgetTester tester, {
  required Widget child,
  List<Override> overrides = const <Override>[],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        locale: const Locale('fr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: child,
      ),
    ),
  );
  await tester.pumpAndSettle();
}
