import 'package:flutter/material.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class GameSetup extends StatefulWidget {
  const GameSetup({super.key, this.onStart});

  final void Function(List<Team> teams)? onStart;

  @override
  State<GameSetup> createState() => _GameSetupState();
}

class _GameSetupState extends State<GameSetup> {
  List<Team> teams = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Setup'),
      ),
      body: Column(children: [
        Expanded(
          flex: 5,
          child: ListView(
            children: [
              Text('(Unassigned)'),
              Placeholder(
                child: Text('Test player'),
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(padding: EdgeInsets.all(8.0), child: Placeholder()),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Placeholder(),
              )
            ],
          ),
        )
      ]),
    );
  }
}
