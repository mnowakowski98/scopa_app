import 'package:flutter/material.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class TeamsListDropdown extends StatelessWidget {
  const TeamsListDropdown(
      {super.key, required this.teams, this.label, this.onTeamSelected});

  final List<Team> teams;
  final String? label;

  final void Function(Team team)? onTeamSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
        onSelected: (value) {
          if (onTeamSelected != null) {
            onTeamSelected!(teams.singleWhere((team) => team.name == value));
          }
        },
        label: Text(label ?? ''),
        initialSelection: teams.first.name,
        dropdownMenuEntries: [
          for (final team in teams)
            DropdownMenuEntry(value: team.name, label: team.name)
        ]);
  }
}
