import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techmarket/core/widgets/error_view.dart';

void main() {
  testWidgets('ErrorView displays the message text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ErrorView(message: 'Pas de connexion internet.')),
    );

    expect(find.text('Pas de connexion internet.'), findsOneWidget);
  });

  testWidgets('ErrorView shows a retry button and calls onRetry when tapped',
      (WidgetTester tester) async {
    bool retried = false;

    await tester.pumpWidget(
      MaterialApp(
        home: ErrorView(
          message: 'Erreur',
          onRetry: () => retried = true,
        ),
      ),
    );

    expect(find.text('Réessayer'), findsOneWidget);
    await tester.tap(find.text('Réessayer'));
    await tester.pump();

    expect(retried, isTrue);
  });

  testWidgets('ErrorView hides the retry button when onRetry is null',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ErrorView(message: 'Erreur')),
    );

    expect(find.text('Réessayer'), findsNothing);
  });
}
