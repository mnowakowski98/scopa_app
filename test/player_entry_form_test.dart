import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/player_entry_form.dart';

void main() {
  testWidgets('calls onAdd when a player is added', (widgetTester) async {
    var callbackwasCalled = false;
    void onAdd() => callbackwasCalled = true;

    await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: PlayerEntryForm(
        teamName: 'Test',
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
}
