import 'package:flutter/material.dart';
import 'package:scopa_lib/tabletop_lib.dart' as tabletop_lib;

class TeamCard extends StatelessWidget {
  const TeamCard(
      {super.key, required this.team, required this.score, this.onHandCardTap});

  final tabletop_lib.Team team;
  final int score;

  final void Function(tabletop_lib.Card)? onHandCardTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Text(
            team.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(score.toString()),
        ]),
      ),
    );
  }
}
