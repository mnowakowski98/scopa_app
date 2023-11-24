import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/player_card.dart';
import 'package:scopa_lib/tabletop_lib.dart' as tabletop_lib;

void main() {
  testWidgets('Shows the player name', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
        home: PlayerCard(name: 'Test', hand: [], fishes: [])));

    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('Shows the player hand', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
        home: PlayerCard(
            name: '', hand: [tabletop_lib.Card('TestSuite', 1)], fishes: [])));

    expect(find.textContaining('TestSuite'), findsOneWidget);
    expect(find.textContaining('1'), findsOneWidget);
  });

  testWidgets('Shows the player fishes', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
        home: PlayerCard(
            name: '', hand: [], fishes: [tabletop_lib.Card('TestSuite', 1)])));

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
}
