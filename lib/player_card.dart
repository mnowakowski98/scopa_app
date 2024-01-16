import 'package:flutter/material.dart';
import 'package:scopa_app/game_card.dart';

class PlayerCard extends StatelessWidget {
  const PlayerCard(
      {super.key,
      required this.name,
      required this.hand,
      required this.fishes,
      this.isCurrent = false,
      this.scopas = 0,
      this.teamScore});

  final bool isCurrent;
  final String name;
  final List<(String, String)> hand;
  final List<(String, String)> fishes;
  final int scopas;
  final int? teamScore;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCurrent ? Colors.green : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              '${teamScore != null ? "Score: $teamScore " : ''}Scopas: $scopas'),
          if (hand.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  for (final card in hand)
                    GameCard(
                      suite: card.$1,
                      value: card.$2,
                      enableDragging: isCurrent,
                    )
                ],
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('No cards'),
            ),
          if (fishes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  for (final card in fishes)
                    GameCard(
                      suite: card.$1,
                      value: card.$2,
                    )
                ],
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No fish'),
            )
        ]),
      ),
    );
  }
}
