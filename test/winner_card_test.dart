import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/winner_card.dart';

void main() {
  testWidgets('Displays the name of winning teams', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
      home: WinnerCard(teamScores: {'Test Team': 11}),
    ));

    expect(find.text('Test Team'), findsOneWidget);
  });

  testWidgets('Displays the score of winning teams', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
      home: WinnerCard(teamScores: {'Test Team': 11}),
    ));

    expect(find.text('Test Team'), findsOneWidget);
    expect(find.text('11'), findsOneWidget);
  });
}
