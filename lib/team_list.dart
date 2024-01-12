import 'package:flutter/material.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class TeamList extends StatelessWidget {
  const TeamList({super.key, required this.team});

  final Team team;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: Column(
            children: [Text(team.name), const Divider()],
          ),
        ),
      ],
      body: team.players.isNotEmpty
          ? ListView.builder(
              itemCount: team.players.length,
              itemBuilder: (context, index) => Text(team.players[index].name),
            )
          : const Center(child: Text('No players')),
    );
  }
}
