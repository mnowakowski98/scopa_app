import 'package:flutter/material.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class TeamList extends StatelessWidget {
  const TeamList({super.key, required this.team});

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(team.name),
          Expanded(
            child: ListView.builder(
              itemCount: team.players.length,
              itemBuilder: (context, index) => Text(team.players[index].name),
            ),
          )
        ],
      ),
    );
  }
}
