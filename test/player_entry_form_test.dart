import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/player_entry_form.dart';
import 'package:scopa_lib/tabletop_lib.dart';

void main() {
  testWidgets('calls onAdd when a player is added', (widgetTester) async {
    var callbackwasCalled = false;
    void onAdd() => callbackwasCalled = true;

    await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: PlayerEntryForm(
        onAdd: (player, team) => onAdd(),
      ),
    )));

    const testPlayerName = 'Test Player';
    final textInput = find.byType(TextField);
    await widgetTester.enterText(textInput, testPlayerName);
    await widgetTester.pump();

    final addButton = find.text('Add');
    await widgetTester.tap(addButton);
    await widgetTester.pump();

    expect(callbackwasCalled, isTrue);
  });

  testWidgets('displays a list of teams to add the player to',
      (widgetTester) async {
    const team1Name = 'Test team 1';
    const team2Name = 'Test team 2';

    await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: PlayerEntryForm(
        teams: [
          Team.players([], name: '(Unassigned)'),
          Team.players([], name: team1Name),
          Team.players([], name: team2Name),
        ],
      ),
    )));

    final team1 = find.text(team1Name);
    final team2 = find.text(team2Name);

    expect(team1, findsOneWidget);
    expect(team2, findsOneWidget);
  });
}
