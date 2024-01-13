import 'package:flutter/material.dart';
import 'package:scopa_app/player_entry_form.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class TeamList extends StatelessWidget {
  const TeamList({super.key, required this.team, this.onPlayerAdd});

  final Team team;
  final void Function(Player player, Team team)? onPlayerAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(team.name),
        const Divider(),
        for (final player in team.players) Text(player.name),
        if (team.players.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('No players'),
          ),
        PlayerEntryForm(
          onAdd: onPlayerAdd,
          team: team,
        ),
      ],
    );
  }
}
