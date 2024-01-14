import 'package:flutter/material.dart';
import 'package:scopa_app/game_card.dart';

class TableHand extends StatelessWidget {
  const TableHand(
      {super.key,
      required this.cards,
      this.onCardDrop,
      required this.selectedCards,
      this.onCardTap});

  final List<(String, String)> cards;
  final List<(String, String)> selectedCards;
  final void Function((String, String) card)? onCardDrop;
  final void Function((String, String) card)? onCardTap;

  @override
  Widget build(BuildContext context) {
    return DragTarget<(String, String)>(
      onAccept: (card) {
        if (onCardDrop != null) {
          onCardDrop!(card);
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                for (final card in cards)
                  GameCard(
                    suite: card.$1,
                    value: card.$2,
                    isSelected: selectedCards.contains(card),
                    onTap: () {
                      if (onCardTap != null) {
                        onCardTap!(card);
                      }
                    },
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
