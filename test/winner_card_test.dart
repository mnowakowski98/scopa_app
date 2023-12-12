import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/winner_card.dart';
import 'package:scopa_lib/tabletop_lib.dart';

void main() {
  testWidgets('Displays the name of winning teams', (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
      home: WinnerCard(teamScores: {Team.players([], name: 'Test Team'): 11}),
    ));

    expect(find.text('Test Team'), findsOneWidget);
  });

  testWidgets('Displays the score of winning teams', (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
      home: WinnerCard(teamScores: {Team.players([], name: 'Test Team'): 11}),
    ));

    expect(find.text('11'), findsOneWidget);
  });
}
