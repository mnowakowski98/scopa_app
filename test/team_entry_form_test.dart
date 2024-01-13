import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/team_entry_form.dart';

void main() {
  testWidgets('calls onAdd when a team is added', (widgetTester) async {
    var callbackwasCalled = false;
    void onAdd() => callbackwasCalled = true;

    await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: TeamEntryForm(
        onAdd: (team) => onAdd(),
      ),
    )));

    const testTeamName = 'Test Player';
    final textInput = find.byType(TextField);
    await widgetTester.enterText(textInput, testTeamName);
    await widgetTester.pump();

    final addButton = find.text('Add');
    await widgetTester.tap(addButton);
    await widgetTester.pump();

    expect(callbackwasCalled, isTrue);
  });
}
