import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/game_card.dart';

void main() {
  testWidgets('Shows the card suite and value', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
        home: GameCard(
      suite: 'Test',
      value: '1',
    )));

    expect(find.text('1\nTest'), findsOneWidget);
  });

  testWidgets('Calls onTap when tapped', (widgetTester) async {
    var callbackWasCalled = false;
    await widgetTester.pumpWidget(MaterialApp(
        home: GameCard(
      suite: 'Test',
      value: '1',
      onTap: () {
        callbackWasCalled = true;
      },
    )));

    await widgetTester.tap(find.textContaining('Test'));

    expect(callbackWasCalled, isTrue);
  });

  testWidgets('Is highlighted blue when selected', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
        home: GameCard(
      suite: 'Test',
      value: '1',
      isSelected: true,
    )));

    final card = widgetTester.widget<Card>(find.byType(Card));

    expect(card.color, equals(Colors.blue));
  });
}
