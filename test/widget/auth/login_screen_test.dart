import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techmarket/features/auth/presentation/screens/login_screen.dart';

import '../test_harness.dart';

void main() {
  testWidgets('LoginScreen renders username, password fields and submit button',
      (WidgetTester tester) async {
    await pumpLocalizedWidget(tester, child: const LoginScreen());

    expect(find.byKey(const Key('login_username_field')), findsOneWidget);
    expect(find.byKey(const Key('login_password_field')), findsOneWidget);
    expect(find.byKey(const Key('login_submit_button')), findsOneWidget);
  });

  testWidgets('LoginScreen shows validation errors when submitting empty fields',
      (WidgetTester tester) async {
    await pumpLocalizedWidget(tester, child: const LoginScreen());

    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pump();

    expect(find.text('Nom d\'utilisateur'), findsOneWidget);
  });

  testWidgets('LoginScreen toggles password visibility icon on tap',
      (WidgetTester tester) async {
    await pumpLocalizedWidget(tester, child: const LoginScreen());

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });
}
