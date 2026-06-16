import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sedi_pay/features/auth/presentation/views/sign_up_view.dart';
import 'package:sedi_pay/features/auth/presentation/widgets/google_auth_button.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: SignUpView(),
      ),
    );
  }

  group('SignUpScreen', () {
    testWidgets('renders intro text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

      expect(find.text('Join Sedi Pay Today.'), findsOneWidget);
      expect(
        find.text(
            'The ultimate one-stop shop to power your day—instantly buy cheap data, airtime, electricity, educational pins, and fund betting wallets in seconds.'),
        findsOneWidget,
      );
    });

    testWidgets('renders Google sign up button', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

      expect(find.text('Sign up with Google'), findsOneWidget);
      expect(find.byType(GoogleAuthButton), findsOneWidget);
    });

    testWidgets('renders sign in link', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
    });
  });
}
