import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/game.dart';
import 'package:scopa_app/game_card.dart';
import 'package:scopa_app/player_card.dart';
import 'package:scopa_app/table_hand.dart';
import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart' hide Card;

void main() {
  testWidgets('Shows a list of players', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: GamePage(
          game: Game([
        Team.players([Player('Test 1')]),
        Team.players([Player('Test 2')]),
      ])),
    ));

    expect(find.text('Test 1'), findsOneWidget);
    expect(find.text('Test 2'), findsOneWidget);
  });
  testWidgets('Shows the table hand cards', (tester) async {
    await tester.pumpWidget(MaterialApp(home: GamePage(game: Game([]))));

    expect(find.byType(GameCard), findsWidgets);
  });

  testWidgets('Highlights the current player green', (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: GamePage(
            game: Game([
      Team.players([Player('test 1')]),
      Team.players([Player('test 2')]),
    ]))));

    final player1Card = widgetTester.widget<Card>(find
        .ancestor(of: find.text('test 1'), matching: find.byType(Card))
        .first);
    expect(player1Card.color, equals(Colors.green));
  });

  testWidgets('Highlights a card blue in the current player hand on tap',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: GamePage(
            game: Game([
      Team.players([Player('Test 1')]),
      Team.players([Player('Test 2')]),
    ]))));

    final playerCard = find.byType(PlayerCard).first;
    final gameCard =
        find.descendant(of: playerCard, matching: find.byType(GameCard)).first;

    final gameCardRoot =
        find.descendant(of: gameCard, matching: find.byType(Card));

    await widgetTester.tap(gameCard);
    await widgetTester.pumpAndSettle();

    final gameCardWidget = widgetTester.widget<Card>(gameCardRoot);

    expect(gameCardWidget.color, equals(Colors.blue));
  });

  testWidgets('Does not select player hand cards in non-current players',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: GamePage(
            game: Game([
      Team.players([Player('Test 1')]),
      Team.players([Player('Test 2')]),
    ]))));

    final playerCard = find.byType(PlayerCard).last;
    final gameCard =
        find.descendant(of: playerCard, matching: find.byType(GameCard)).first;

    final gameCardRoot =
        find.descendant(of: gameCard, matching: find.byType(Card));

    await widgetTester.tap(gameCard);
    await widgetTester.pumpAndSettle();

    final gameCardWidget = widgetTester.widget<Card>(gameCardRoot);

    expect(gameCardWidget.color, isNull);
  });

  testWidgets('Can drag a card from the player hand to the table to play it',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: GamePage(
            game: Game([
      Team.players([Player('Test')])
    ]))));

    final playerCard = find.byType(PlayerCard).first;
    final gameCard =
        find.descendant(of: playerCard, matching: find.byType(GameCard)).first;
    final gameCardCenter = widgetTester.getCenter(gameCard);
    final gameCardText =
        find.descendant(of: gameCard, matching: find.byType(Text)).first;

    final gameCardString = widgetTester.widget<Text>(gameCardText).data!;

    final tablehand = find.byType(TableHand);
    final tableHandCenter = widgetTester.getCenter(tablehand);

    final gesture = await widgetTester.startGesture(gameCardCenter);
    await widgetTester.pump();

    await gesture.moveTo(tableHandCenter);
    await widgetTester.pump();
    await gesture.up();
    await widgetTester.pump();

    final gameCardInTableHand =
        find.descendant(of: tablehand, matching: find.text(gameCardString));

    expect(gameCardInTableHand, findsOneWidget);
  });

  testWidgets('Can not play a card from a non-current player hand',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: GamePage(
            game: Game([
      Team.players([Player('Test 1'), Player('Test 2')])
    ]))));

    final playerCard = find.byType(PlayerCard).last;
    final gameCard =
        find.descendant(of: playerCard, matching: find.byType(GameCard)).first;
    final gameCardCenter = widgetTester.getCenter(gameCard);
    final gameCardText =
        find.descendant(of: gameCard, matching: find.byType(Text)).first;

    final gameCardString = widgetTester.widget<Text>(gameCardText).data!;

    final tablehand = find.byType(TableHand);
    final tableHandCenter = widgetTester.getCenter(tablehand);

    final gesture = await widgetTester.startGesture(gameCardCenter);
    await widgetTester.pump();

    await gesture.moveTo(tableHandCenter);
    await widgetTester.pump();
    await gesture.up();
    await widgetTester.pump();

    final gameCardInTableHand =
        find.descendant(of: tablehand, matching: find.text(gameCardString));

    expect(gameCardInTableHand, findsNothing);
  });
}
