import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/team_list.dart';

void main() {
  testWidgets('Shows a list of players', (widgetTester) async {
    const player1Name = 'Test player 1';
    const player2Name = 'Test player 2';

    await widgetTester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: TeamList(
          teamName: 'Test',
          playerNames: [player1Name, player2Name],
        ),
      ),
    ));

    final player1 = find.text(player1Name);
    final player2 = find.text(player2Name);

    expect(player1, findsOneWidget);
    expect(player2, findsOneWidget);
  });
}
