// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:jimma_voice_app/main.dart';

void main() {
  testWidgets('voice room gifts convert coins into diamonds', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Jimma Voice Party'), findsOneWidget);
    expect(find.text('30,000'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('Buna'));
    await tester.pumpAndSettle();

    expect(find.text('25,000'), findsOneWidget);
    expect(find.text('3,500'), findsOneWidget);
  });

  testWidgets('top-up sheet lists supported payment methods', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Top up'));
    await tester.pumpAndSettle();

    expect(find.text('Telebirr'), findsOneWidget);
    expect(find.text('M-Pesa'), findsOneWidget);
    expect(find.text('CBE'), findsOneWidget);
    expect(find.text('Awash'), findsOneWidget);
    expect(find.text('Abyssinia'), findsOneWidget);
    expect(find.text('USDT'), findsOneWidget);
    expect(find.text('Visa'), findsOneWidget);
  });
}
