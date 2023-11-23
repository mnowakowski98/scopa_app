import 'package:flutter_test/flutter_test.dart';
import 'package:scopa_app/game.dart';
import 'package:scopa_app/main.dart';

void main() {
  testWidgets('shows the game page when the game button is clicked',
      (tester) async {
    await tester.pumpWidget(const ScopaApp());

    final gameButton = find.text('Start Game');
    expect(gameButton, findsOneWidget);

    await tester.tap(gameButton);
    await tester.pumpAndSettle();

    expect(find.byType(GamePage), findsOneWidget);
  });
}
