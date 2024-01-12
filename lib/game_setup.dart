import 'package:flutter/material.dart';
import 'package:scopa_app/game.dart';
import 'package:scopa_app/player_entry_form.dart';
import 'package:scopa_app/team_entry_form.dart';
import 'package:scopa_app/teams_list.dart';
import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class GameSetup extends StatefulWidget {
  const GameSetup({super.key});

  @override
  State<GameSetup> createState() => _GameSetupState();
}

class _GameSetupState extends State<GameSetup> {
  final _unassignedPlayers = <Player>[];

  final _teams = <Team>[];

  void addPlayer(Player player, Team team) {
    if (_teams.contains(team) == false) {
      setState(() {
        _unassignedPlayers.add(player);
      });
    } else {
      final newPlayers = team.players + [player];
      setState(() {
        _teams[_teams.indexOf(team)] =
            Team.players(newPlayers, name: team.name);
      });
    }
  }

  void addTeam(Team team) {
    setState(() {
      _teams.add(team);
    });
  }

  void assignPlayer(Player player, Team team) {
    setState(() {
      _unassignedPlayers.remove(player);
      for (var element in _teams) {
        element.players.remove(player);
      }
      _teams.singleWhere((element) => element == team).players.add(player);
    });
  }

  @override
  Widget build(BuildContext context) {
    final unassignedTeam =
        Team.players(_unassignedPlayers, name: '(Unassigned)');
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Expanded(child: Text('Game Setup')),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GamePage(
                            game: Game([
                                  for (final player in _unassignedPlayers)
                                    Team.players([player]),
                                ] +
                                _teams)),
                      ));
                    },
                    child: const Text('Start')),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TeamEntryForm(
                onAdd: addTeam,
              ),
              const Divider(),
              PlayerEntryForm(
                onAdd: addPlayer,
                teams: [unassignedTeam] + _teams,
              ),
              const Divider(),
              Expanded(
                child: TeamsList(
                  teams: [unassignedTeam] + _teams,
                ),
              )
            ],
          ),
        ));
  }
}
