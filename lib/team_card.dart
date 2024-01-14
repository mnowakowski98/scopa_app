import 'package:flutter/material.dart';
import 'package:scopa_lib/tabletop_lib.dart' as tabletop_lib;

class TeamCard extends StatelessWidget {
  const TeamCard(
      {super.key,
      required this.score,
      this.onHandCardTap,
      required this.teamName});

  final String teamName;
  final int score;

  final void Function(tabletop_lib.Card)? onHandCardTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Text(
            teamName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(score.toString()),
        ]),
      ),
    );
  }
}
