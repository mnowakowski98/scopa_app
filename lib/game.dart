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
  late Map<String, List<tabletop_lib.Card>> playerCards;
  late Map<String, List<tabletop_lib.Card>> playerFishes;

  @override
  void initState() {
    super.initState();
    currentRound = widget.game.nextRound();
    tableCards = List.unmodifiable(widget.game.table.round.cards);
    playerCards = Map.unmodifiable(currentRound.playerHands
        .map((key, value) => MapEntry(key.name, value.cards)));
    playerFishes = Map.unmodifiable(currentRound.captureHands
        .map((key, value) => MapEntry(key.name, value.cards)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Game')),
        body: NestedScrollView(
            headerSliverBuilder: (context, q) => [
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          children: [
                            for (final card in tableCards) GameCard(card: card)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
            body: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: widget.game.teams.length,
                itemBuilder: ((context, index) {
                  final team = widget.game.teams[index];
                  return Card(
                      child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Text(team.name),
                          const Text('[team.score]'),
                        ]),
                      ))
                    ],
                    body: ListView.builder(
                      itemCount: team.players.length,
                      itemBuilder: (context, index) {
                        final player = team.players[index];
                        return PlayerCard(
                          name: player.name,
                          hand: playerCards[player.name]!,
                          fishes: playerFishes[player.name]!,
                          isCurrent: currentRound.currentPlayer == player,
                        );
                      },
                    ),
                  ));
                }))));
  }
}
