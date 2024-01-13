import 'package:flutter/material.dart';
import 'package:scopa_app/game.dart';
import 'package:scopa_app/teams_list.dart';
import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class GameSetup extends StatefulWidget {
  const GameSetup({super.key});

  @override
  State<GameSetup> createState() => _GameSetupState();
}

class _GameSetupState extends State<GameSetup> {
  final _unassignedPlayers = <String>[];

  final _teams = <String, List<String>>{};

  void addPlayer(String playerName, String teamName) {
    if (_teams.keys.contains(teamName) == false) {
      setState(() {
        _unassignedPlayers.add(playerName);
      });
    } else {
      setState(() {
        _teams[teamName]!.add(playerName);
      });
    }
  }

  void addTeam(String teamName) {
    setState(() {
      _teams[teamName] = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final combinedTeams = Map.of({'(Unassigned)': _unassignedPlayers});
    combinedTeams.addAll(_teams);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const Expanded(child: Text('Game Setup')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GamePage(
                            game: Game([
                                  for (final player in _unassignedPlayers)
                                    Team.players([Player(player)]),
                                ] +
                                _teams.entries
                                    .map((team) => Team.players(team.value
                                        .map((player) => Player(player))
                                        .toList()))
                                    .toList())),
                      ));
                    },
                    child: const Text('Start')),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TeamsList(
                onTeamAdd: addTeam,
                onPlayerAdd: addPlayer,
                teams: combinedTeams),
          )),
    );
  }
}
