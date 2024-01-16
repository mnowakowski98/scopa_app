import 'package:flutter/material.dart';
import 'package:scopa_app/player_card.dart';
import 'package:scopa_app/table_hand.dart';
import 'package:scopa_app/team_card.dart';
import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart' as tabletop show Card;

class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
    required this.game,
    this.initialRound,
  });

  final Game game;
  final ScopaRound? initialRound;

  @override
  State<GamePage> createState() => _GamePageState();
}

class TeamInfo {
  TeamInfo(
      {required this.id,
      required this.name,
      required this.playerNames,
      required this.score});

  final int id;
  final String name;
  final List<String> playerNames;
  final int score;
}

class _GamePageState extends State<GamePage> {
  var _teams = <TeamInfo>[];
  var _tableCards = <(String, String)>[];

  late ScopaRound _round;
  late String _currentPlayer;
  var _playerCards = <String, List<(String, String)>>{};
  var _playerFish = <String, List<(String, String)>>{};
  var _playerScopaCount = <String, int>{};

  final _selectedCards = <(String, String)>[];

  void _updateGameState() {
    if (_round.currentPlayer != null) {
      _currentPlayer = _round.currentPlayer!.name;
    }

    _teams = [];
    final teams = widget.game.teams;
    for (var i = 0; i < teams.length; i++) {
      final info = TeamInfo(
          id: i,
          name: teams[i].name,
          playerNames: teams[i].players.map((player) => player.name).toList(),
          score: widget.game.teamScores[teams[i]]!);
      _teams.add(info);
    }

    _tableCards = widget.game.table.round.cards
        .map((card) => (card.suite, card.value.toString()))
        .toList();

    _playerCards = _round.playerHands.map((player, hand) => MapEntry(
        player.name,
        hand.cards
            .map((card) => (card.suite, card.value.toString()))
            .toList()));

    _playerFish = _round.captureHands.map((player, hand) => MapEntry(
        player.name,
        hand.cards
            .map((card) => (card.suite, card.value.toString()))
            .toList()));

    _playerScopaCount =
        _round.scopas.map((player, score) => MapEntry(player.name, score));
  }

  @override
  void initState() {
    _round = widget.initialRound == null
        ? widget.game.nextRound()
        : widget.initialRound!;

    _updateGameState();

    super.initState();
  }

  void _playCard((String, String) playCard, List<(String, String)> matchCards) {
    final playCardObj = tabletop.Card(playCard.$1, int.parse(playCard.$2));
    final matchCardObjs = matchCards
        .map((card) => tabletop.Card(card.$1, int.parse(card.$2)))
        .toList();

    if (_round.validatePlay(playCardObj, matchCardObjs) == false) {
      return;
    }

    final roundState = _round.play(playCardObj, matchCardObjs);

    if (roundState == false) {
      final winners = widget.game.scoreRound(_round);
      if (winners != null && winners.isNotEmpty) {
        // TODO: Show winner cards
      }

      _round = widget.game.nextRound();
    }

    setState(() {
      _updateGameState();
      _selectedCards.clear();
    });
  }

  _setCardSelection((String, String) card) {
    setState(() {
      if (_selectedCards.remove(card) == true) return;
      _selectedCards.add(card);
    });
  }

  @override
  Widget build(BuildContext context) {
    final teamsList = <Widget>[];
    for (final teamInfo in _teams) {
      final isNotSinglePlayerUnnamedTeam =
          teamInfo.name.isNotEmpty == true || teamInfo.playerNames.length > 1;
      if (isNotSinglePlayerUnnamedTeam) {
        teamsList.add(TeamCard(score: teamInfo.score, teamName: teamInfo.name));
      }
      teamsList.addAll(teamInfo.playerNames.map((playerName) => PlayerCard(
            name: playerName,
            hand: _playerCards[playerName]!,
            fishes: _playerFish[playerName]!,
            teamScore: isNotSinglePlayerUnnamedTeam ? null : teamInfo.score,
            isCurrent: _currentPlayer == playerName,
          )));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scopa'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          TableHand(
            cards: _tableCards,
            selectedCards: _selectedCards,
            onCardDrop: (card) => _playCard(card, _selectedCards),
            onCardTap: _setCardSelection,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: teamsList.length,
              itemBuilder: (context, index) => teamsList[index],
            ),
          ),
        ],
      )),
    );
  }
}
