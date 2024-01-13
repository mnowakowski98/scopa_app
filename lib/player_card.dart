import 'package:flutter/material.dart';
import 'package:scopa_app/game_card.dart';
import 'package:scopa_lib/tabletop_lib.dart' as tabletop_lib;

class PlayerCard extends StatelessWidget {
  const PlayerCard(
      {super.key,
      required this.name,
      required this.hand,
      required this.fishes,
      this.isCurrent = false,
      this.onHandCardTap,
      this.selectedHandCard,
      this.scopas = 0});

  final bool isCurrent;
  final String name;
  final List<tabletop_lib.Card> hand;
  final List<tabletop_lib.Card> fishes;
  final tabletop_lib.Card? selectedHandCard;
  final void Function(tabletop_lib.Card card)? onHandCardTap;
  final int scopas;

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
          Text(scopas.toString()),
          if (hand.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  for (final card in hand)
                    GameCard(
                      cardFace: CardFace(
                          suite: card.suite, value: card.value.toString()),
                      onTap: () {
                        if (onHandCardTap != null) onHandCardTap!(card);
                      },
                      isSelected: selectedHandCard == card,
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
                      cardFace: CardFace(
                          suite: card.suite, value: card.value.toString()),
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
