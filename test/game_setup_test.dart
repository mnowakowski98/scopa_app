import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/game_setup.dart';

void main() {
  testWidgets('Shows a list of unassigned players', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
      home: GameSetup(),
    ));

    // TODO: Add player as unassigned

    final player = find.text('Test player');

    expect(player, findsOneWidget);
    expect(find.ancestor(of: player, matching: find.byType(ListView)),
        findsOneWidget);
  });
}
