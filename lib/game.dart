import 'package:flutter/material.dart';
import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart' as tabletop_lib;

class GameCard extends StatelessWidget {
  const GameCard({super.key, required this.card});

  final tabletop_lib.Card card;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(card.value.toString()),
        Text(card.suite),
      ],
    );
  }
}

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
              child: GridView.count(
                crossAxisCount: 5,
                children: [
                  for (final seat in widget.game.table.seats)
                    Center(child: Text(seat.player!.name))
                ],
              )),
        ],
      ),
    );
  }
}
