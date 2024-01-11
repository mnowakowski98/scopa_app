import 'package:flutter/material.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class TeamsListDropdown extends StatelessWidget {
  const TeamsListDropdown({super.key, required this.teams});

  final List<Team> teams;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(dropdownMenuEntries: [
      for (final team in teams)
        DropdownMenuEntry(value: team.name, label: team.name)
    ]);
  }
}
