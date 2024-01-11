import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/unassigned_team_list.dart';
import 'package:scopa_lib/tabletop_lib.dart';

void main() {
  testWidgets('Shows a list of unassigned players', (widgetTester) async {
    const player1Name = 'Test player 1';
    const player2Name = 'Test player 2';

    await widgetTester.pumpWidget(MaterialApp(
      home: UnassignedTeamList(
        team: Team.players([
          Player(player1Name),
          Player(player2Name),
        ]),
      ),
    ));

    final player1 = find.text(player1Name);
    final player2 = find.text(player2Name);

    expect(player1, findsOneWidget);
    expect(player2, findsOneWidget);
  });
}
