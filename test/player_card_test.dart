import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/player_card.dart';
import 'package:scopa_lib/tabletop_lib.dart';

void main() {
  testWidgets('Shows the player name', (widgetTester) async {
    await widgetTester
        .pumpWidget(const PlayerCard(name: 'Test', hand: [], fishes: []));

    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('Shows the player hand', (widgetTester) async {
    await widgetTester.pumpWidget(
        const PlayerCard(name: '', hand: [Card('TestSuite', 1)], fishes: []));

    expect(find.textContaining('TestSuite'), findsOneWidget);
    expect(find.textContaining('1'), findsOneWidget);
  });

  testWidgets('Shows the player fishes', (widgetTester) async {
    await widgetTester.pumpWidget(
        const PlayerCard(name: '', hand: [], fishes: [Card('TestSuite', 1)]));

    expect(find.textContaining('TestSuite'), findsOneWidget);
    expect(find.textContaining('1'), findsOneWidget);
  });
}
