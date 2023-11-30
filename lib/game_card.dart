import 'package:flutter/material.dart';
import 'package:scopa_lib/tabletop_lib.dart' as tabletop_lib;

class GameCard extends StatelessWidget {
  const GameCard(
      {super.key, required this.card, this.isSelected = false, this.onTap});

  final tabletop_lib.Card card;
  final bool isSelected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Draggable<tabletop_lib.Card>(
      data: card,
      feedback: const Placeholder(),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: isSelected ? Colors.blue : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${card.value}\n${card.suite}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
