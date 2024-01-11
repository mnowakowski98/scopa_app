import 'package:flutter/material.dart';
import 'package:scopa_app/player_entry_form.dart';
import 'package:scopa_app/unassigned_team_list.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class GameSetup extends StatefulWidget {
  const GameSetup({super.key});

  @override
  State<GameSetup> createState() => _GameSetupState();
}

class _GameSetupState extends State<GameSetup> {
  final _unassigned = <Player>[];
  final _teams = <Team>[];

  void addPlayer(Player player) {
    setState(() {
      _unassigned.add(player);
    });
  }

  void assignPlayer(Player player, Team team) {
    setState(() {
      _unassigned.remove(player);
      for (var element in _teams) {
        element.players.remove(player);
      }
      _teams.singleWhere((element) => element == team).players.add(player);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Setup'),
      ),
      body: Column(children: [
        PlayerEntryForm(
          onAdd: addPlayer,
        ),
        UnassignedTeamList(
          players: _unassigned,
        )
      ]),
    );
  }
}
