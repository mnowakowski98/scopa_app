import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/teams_list_dropdown.dart';

void main() {
  testWidgets('displays a list of team names', (widgetTester) async {
    const team1Name = 'Test player 1';
    const team2Name = 'Test player 2';

    await widgetTester.pumpWidget(const MaterialApp(
      home: TeamsListDropdown(
        teamNames: [team1Name, team2Name],
      ),
    ));

    final team1 = find.text(team1Name);
    final team2 = find.text(team2Name);

    expect(team1, findsOneWidget);
    expect(team2, findsOneWidget);
  });
}
