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

  testWidgets('Shows the score for each team', (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
      home: GamePage(
          game: Game([
        Team.players([Player('Test 1')], name: 'Team 1'),
      ])),
    ));

    final teamName = find.text('Team 1');
    final teamCard = find.ancestor(of: teamName, matching: find.byType(Card));

    expect(find.descendant(of: teamCard, matching: find.text('0')),
        findsOneWidget);
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

  testWidgets('Can unselect a selected table card', (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(home: GamePage(game: Game([]))));

    final tableHand = find.byType(TableHand);
    final tableCard =
        find.descendant(of: tableHand, matching: find.byType(GameCard)).first;

    await widgetTester.tap(tableCard);
    await widgetTester.pump();

    await widgetTester.tap(tableCard);
    await widgetTester.pump();

    final tableCardWidget = widgetTester.widget<Card>(
        find.descendant(of: tableCard, matching: find.byType(Card)));

    expect(tableCardWidget.color, isNull);
  });

  testWidgets('Can select multiple table cards in the table hand',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(home: GamePage(game: Game([]))));

    final tableHand = find.byType(TableHand);
    final tableCard1 =
        find.descendant(of: tableHand, matching: find.byType(GameCard)).first;
    final tableCard2 =
        find.descendant(of: tableHand, matching: find.byType(GameCard)).last;

    await widgetTester.tap(tableCard1);
    await widgetTester.pump();

    await widgetTester.tap(tableCard2);
    await widgetTester.pump();

    final tableCard1Widget = widgetTester.widget<Card>(
        find.descendant(of: tableCard1, matching: find.byType(Card)));
    final tableCard2Widget = widgetTester.widget<Card>(
        find.descendant(of: tableCard1, matching: find.byType(Card)));

    expect(tableCard1Widget.color, equals(Colors.blue));
    expect(tableCard2Widget.color, equals(Colors.blue));
  });

  testWidgets(
      'Can capture table cards by playing a card with table cards selected',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
        home: GamePage(
            game: Game([
      Team.players([Player('Test 1'), Player('Test 2')])
    ]))));

    // TODO: Rig the deck somehow

    // TODO: Select a table card

    // TODO: Select drag a matching card from current player's hand to the table

    // TODO: Check both cards are in the current player's fishes
  });
}
