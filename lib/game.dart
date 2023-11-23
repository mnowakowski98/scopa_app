import 'package:flutter/material.dart';
import 'package:scopa_lib/scopa_lib.dart';

class PlayerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class GamePage extends StatelessWidget {
  const GamePage({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Placeholder(
              child: Text('Table hands'),
            ),
          ),
          Expanded(flex: 2, child: Placeholder(child: Text('Player grid'))),
        ],
      ),
    );
  }
}
