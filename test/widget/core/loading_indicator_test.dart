import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techmarket/core/widgets/loading_indicator.dart';

void main() {
  testWidgets('LoadingIndicator shows a CircularProgressIndicator',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoadingIndicator()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('LoadingIndicator exposes a semantics label for screen readers',
      (WidgetTester tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();

    await tester.pumpWidget(
      const MaterialApp(home: LoadingIndicator(label: 'Chargement des produits')),
    );

    expect(find.bySemanticsLabel('Chargement des produits'), findsOneWidget);
    handle.dispose();
  });
}
