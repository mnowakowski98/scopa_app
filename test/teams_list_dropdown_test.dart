import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/teams_list_dropdown.dart';
import 'package:scopa_lib/tabletop_lib.dart';

void main() {
  testWidgets('displays a list of team names on tap', (widgetTester) async {
    const team1Name = 'Test team 1';
    const team2Name = 'Test team 2';

    await widgetTester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TeamsListDropdown(
          teams: [
            Team.players([], name: '(Unassigned)'),
            Team.players([], name: team1Name),
            Team.players([], name: team2Name),
          ],
        ),
      ),
    ));

    final team1 = find.text(team1Name);
    final team2 = find.text(team2Name);

    expect(team1, findsOneWidget);
    expect(team2, findsOneWidget);
  });
}
