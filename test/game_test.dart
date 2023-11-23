import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/game.dart';
import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';

void main() {
  testWidgets('Shows a list of players', (tester) async {
    await tester.pumpWidget(GamePage(
        game: Game({
      Team.players([Player('Test 1')]),
      Team.players([Player('Test 2')]),
    })));

    expect(find.text('Test 1'), findsOneWidget);
    expect(find.text('Test 2'), findsOneWidget);
  });
  testWidgets('Shows the table hand cards', (tester) async {
    await tester.pumpWidget(GamePage(game: Game({})));

    expect(find.byType(PlayerCard), findsWidgets);
  });
}
