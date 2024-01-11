import 'package:flutter/material.dart';
import 'package:scopa_app/game_setup.dart';

// coverage:ignore-start
void main() {
  runApp(const ScopaApp());
}
// coverage:ignore-end

class ScopaApp extends StatelessWidget {
  const ScopaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scopa App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const SafeArea(child: HomePage()),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const GameSetup()));
              },
              child: const Text('Start Game'))),
    );
  }
}
