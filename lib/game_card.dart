import 'package:flutter/material.dart';
import 'package:scopa_lib/tabletop_lib.dart' as tabletop_lib;

class GameCard extends StatelessWidget {
  const GameCard({super.key, required this.card});

  final tabletop_lib.Card card;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(card.value.toString()),
            Text(card.suite),
          ],
        ),
      ),
    );
  }
}
