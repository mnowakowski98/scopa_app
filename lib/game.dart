import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

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
