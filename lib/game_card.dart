import 'package:flutter/material.dart';

class CardFace extends StatelessWidget {
  const CardFace({super.key, required this.suite, required this.value});

  final String suite;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '$value\n$suite',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    this.isSelected = false,
    this.enableDragging = false,
    this.onTap,
    required this.cardFace,
  });

  final CardFace cardFace;
  final bool isSelected;
  final bool enableDragging;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    if (enableDragging == false) {
      return GestureDetector(onTap: onTap, child: cardFace);
    }

    return Draggable<CardFace>(
      data: cardFace,
      feedback: cardFace,
      child: GestureDetector(onTap: onTap, child: cardFace),
    );
  }
}
