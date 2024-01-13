import 'package:flutter/material.dart';
import 'package:scopa_app/game_setup/player_entry_form.dart';

class TeamList extends StatelessWidget {
  const TeamList(
      {super.key,
      this.onPlayerAdd,
      required this.teamName,
      required this.playerNames});

  final String teamName;
  final List<String> playerNames;
  final void Function(String playerName, String teamName)? onPlayerAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(teamName),
        const Divider(),
        for (final player in playerNames) Text(player),
        if (playerNames.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('No players'),
          ),
        PlayerEntryForm(
          onAdd: onPlayerAdd,
          teamName: teamName,
        ),
      ],
    );
  }
}
