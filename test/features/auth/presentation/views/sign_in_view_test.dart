import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sedi_pay/features/auth/presentation/views/sign_in_view.dart';
import 'package:sedi_pay/features/auth/presentation/widgets/google_auth_button.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: SignInView(),
      ),
    );
  }

  group('SignInScreen', () {
    testWidgets('renders intro text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

      expect(find.text('Instant Services.\nZero Friction.'), findsOneWidget);
      expect(
        find.text(
            'The ultimate one-stop shop to power your day—instantly buy cheap data, airtime, electricity, educational pins, and fund betting wallets in seconds.'),
        findsOneWidget,
      );
    });

    testWidgets('renders Google sign in button', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.byType(GoogleAuthButton), findsOneWidget);
    });

    testWidgets('renders sign up link', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
    });
  });
}
