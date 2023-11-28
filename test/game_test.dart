import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/game.dart';
import 'package:scopa_app/game_card.dart';
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
}
