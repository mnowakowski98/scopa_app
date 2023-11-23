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
}
