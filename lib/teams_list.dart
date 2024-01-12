import 'package:flutter/material.dart';
import 'package:scopa_app/team_list.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class TeamsList extends StatelessWidget {
  const TeamsList({super.key, required this.teams});

  final List<Team> teams;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: teams.length,
        itemExtentBuilder: (index, dimensions) =>
            dimensions.viewportMainAxisExtent / 4,
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: TeamList(team: teams[index]),
            ));
  }
}
