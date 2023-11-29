import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/game_card.dart';
import 'package:scopa_lib/tabletop_lib.dart' as tabletop_lib;

void main() {
  testWidgets('Shows the card suite and value', (widgetTester) async {
    await widgetTester.pumpWidget(
        const MaterialApp(home: GameCard(card: tabletop_lib.Card('Test', 1))));

    expect(find.text('Test'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Calls onTap when tapped', (widgetTester) async {
    var callbackWasCalled = false;
    await widgetTester.pumpWidget(MaterialApp(
        home: GameCard(
      card: const tabletop_lib.Card('Test', 1),
      onTap: () {
        callbackWasCalled = true;
      },
    )));

    await widgetTester.tap(find.text('Test'));

    expect(callbackWasCalled, isTrue);
  });

  testWidgets('Is highlighted blue when selected', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
        home: GameCard(
      card: tabletop_lib.Card('Test', 1),
      isSelected: true,
    )));

    final card = widgetTester.widget<Card>(find.byType(Card));

    expect(card.color, equals(Colors.blue));
  });
}
