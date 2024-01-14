import 'package:flutter/material.dart';

class CardFace extends StatelessWidget {
  const CardFace(
      {super.key, required this.suite, required this.value, this.background});

  final String suite;
  final String value;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: background,
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
    required this.suite,
    required this.value,
  });

  final String suite;
  final String value;
  final bool isSelected;
  final bool enableDragging;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final cardFace = CardFace(
      suite: suite,
      value: value,
      background: isSelected ? Colors.blue : null,
    );

    if (enableDragging == false) {
      return GestureDetector(onTap: onTap, child: cardFace);
    }

    return Draggable<(String, String)>(
      data: (cardFace.suite, cardFace.value),
      feedback: cardFace,
      child: GestureDetector(onTap: onTap, child: cardFace),
    );
  }
}
