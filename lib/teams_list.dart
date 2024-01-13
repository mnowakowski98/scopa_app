import 'package:flutter/material.dart';
import 'package:scopa_app/team_entry_form.dart';
import 'package:scopa_app/team_list.dart';

class TeamsList extends StatelessWidget {
  const TeamsList(
      {super.key, required this.teams, this.onPlayerAdd, this.onTeamAdd});

  final Map<String, List<String>> teams;
  final void Function(String playerName, String teamName)? onPlayerAdd;
  final void Function(String teamName)? onTeamAdd;

  @override
  Widget build(BuildContext context) {
    Widget teamList(String teamName) => TeamList(
        playerNames: teams[teamName]!,
        onPlayerAdd: onPlayerAdd,
        teamName: teamName);

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
                      child: teamList(teams.keys.elementAt(index)),
                    ),
                  )
                else
                  SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: constraints.maxWidth / 4),
                    itemCount: teams.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: teamList(teams.keys.elementAt(index)),
                    ),
                  )
              ],
            ));
  }
}
