import 'package:flutter/material.dart';
import 'package:scopa_app/team_card.dart';

class WinnerCard extends StatelessWidget {
  const WinnerCard({super.key, required this.teamScores});

  final Map<String, int> teamScores;

  @override
  Widget build(BuildContext context) {
    final winMessage = teamScores.length > 1 ? "Winners!" : "Winner!";
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            winMessage,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final team in teamScores.entries)
                    TeamCard(teamName: team.key, score: team.value)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
