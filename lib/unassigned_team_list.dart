import 'package:flutter/material.dart';
import 'package:scopa_app/team_list.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class UnassignedTeamList extends StatelessWidget {
  const UnassignedTeamList({super.key, required this.players});

  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    return TeamList(team: Team.players(players, name: '(Unassigned)'));
  }
}
