import 'package:flutter/material.dart';
import 'package:scopa_app/team_list.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class UnassignedTeamList extends StatelessWidget {
  const UnassignedTeamList({super.key, required this.team});

  final Team team;

  @override
  Widget build(BuildContext context) {
    return TeamList(team: team);
  }
}
