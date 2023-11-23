import 'package:flutter/material.dart';
import 'package:scopa_app/game.dart';
import 'package:scopa_lib/scopa_lib.dart';

void main() {
  runApp(const ScopaApp());
}

class ScopaApp extends StatelessWidget {
  const ScopaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scopa App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GamePage(
                              game: Game({}),
                            )));
              },
              child: const Text('Start Game'))),
    );
  }
}
