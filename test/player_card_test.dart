import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/player_card.dart';

void main() {
  testWidgets('Shows the player name', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
        home: PlayerCard(name: 'Test', hand: [], fishes: [])));

    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('Shows the player hand', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
        home: PlayerCard(name: '', hand: [('TestSuite', '1')], fishes: [])));

    expect(find.textContaining('TestSuite'), findsOneWidget);
    expect(find.textContaining('1'), findsOneWidget);
  });

  testWidgets('Shows the player fishes', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
        home: PlayerCard(name: '', hand: [], fishes: [('TestSuite', '1')])));

    expect(find.textContaining('TestSuite'), findsOneWidget);
    expect(find.textContaining('1'), findsOneWidget);
  });

  testWidgets('Highlights green when it is current', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
        home: PlayerCard(
      name: 'Test',
      hand: [],
      fishes: [],
      isCurrent: true,
    )));

    final card = widgetTester.widget<Card>(find.byType(Card).first);
    expect(card.color, equals(Colors.green));
  });

  testWidgets('Calls onHandCardTap when a hand card is tapped',
      (widgetTester) async {
    (String, String)? callbackCard;

    await widgetTester.pumpWidget(MaterialApp(
        home: PlayerCard(
            name: 'Test',
            hand: const [('TestSuite', '5')],
            fishes: const [],
            onHandCardTap: (card) {
              callbackCard = card;
            })));

    await widgetTester.tap(find.textContaining('TestSuite'));
    expect(callbackCard, isNotNull);
  });
}
