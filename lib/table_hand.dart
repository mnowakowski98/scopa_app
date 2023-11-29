import 'package:flutter/material.dart';
import 'package:scopa_app/game_card.dart';
import 'package:scopa_lib/tabletop_lib.dart' as tabletop_lib;

class TableHand extends StatelessWidget {
  const TableHand({super.key, required this.cards});

  final List<tabletop_lib.Card> cards;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          children: [for (final card in cards) GameCard(card: card)],
        ),
      ),
    );
  }
}
