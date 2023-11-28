import 'package:flutter/material.dart';
import 'package:scopa_app/game_card.dart';
import 'package:scopa_app/player_card.dart';
import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart' as tabletop_lib;

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.game});

  final Game game;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late ScopaRound currentRound;
  late List<tabletop_lib.Card> tableCards;

  @override
  void initState() {
    super.initState();
    currentRound = widget.game.nextRound();
    tableCards = List.unmodifiable(widget.game.table.round.cards);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  for (final card in tableCards) GameCard(card: card)
                ]),
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: widget.game.teams.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: ((context, index) {
                      final team = widget.game.teams[index];
                      final firstPlayer = team.players[0];
                      return Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(team.name),
                            ),
                            PlayerCard(
                                name: firstPlayer.name,
                                hand: currentRound
                                    .playerHands[firstPlayer]!.cards,
                                fishes: currentRound
                                    .playerHands[firstPlayer]!.cards)
                          ],
                        ),
                      );
                    })),
              )),
        ],
      ),
    );
  }
}
