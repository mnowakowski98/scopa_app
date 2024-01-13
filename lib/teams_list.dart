import 'package:flutter/material.dart';
import 'package:scopa_app/team_entry_form.dart';
import 'package:scopa_app/team_list.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class TeamsList extends StatelessWidget {
  const TeamsList(
      {super.key, required this.teams, this.onPlayerAdd, this.onTeamAdd});

  final List<Team> teams;
  final void Function(Player player, Team team)? onPlayerAdd;
  final void Function(Team team)? onTeamAdd;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  title: TeamEntryForm(
                    onAdd: onTeamAdd,
                  ),
                ),
                if (constraints.maxWidth <= 750)
                  SliverList.builder(
                      itemCount: teams.length,
                      itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TeamList(
                              onPlayerAdd: onPlayerAdd,
                              team: teams[index],
                            ),
                          ))
                else
                  SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: constraints.maxWidth / 4),
                    itemCount: teams.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TeamList(
                          onPlayerAdd: onPlayerAdd, team: teams[index]),
                    ),
                  )
              ],
            ));
  }
}
