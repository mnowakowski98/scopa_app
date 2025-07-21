import 'package:flutter/material.dart';
import 'package:scopa_app/player_card.dart';
import 'package:scopa_app/table_hand.dart';
import 'package:scopa_app/team_card.dart';
import 'package:scopa_app/winner_card.dart';
import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart' as tabletop show Card;

/// A record of player information
class PlayerInfo {
  PlayerInfo(this.name, this.scopaCount);

  final String name;
  final int scopaCount;
}

/// A record of team information
class TeamInfo {
  TeamInfo(
      {required this.id,
      required this.name,
      required this.players,
      required this.score});

  final int id;
  final String name;
  final List<PlayerInfo> players;
  final int score;
}

/// The screen that a game of Scopa is played on
class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
    required this.game,
    this.initialRound,
  });

  /// The [Game] object that the state is derived from.
  final Game game;

  /// An optional pre-configured round to start with.
  /// Right now just for testing
  final ScopaRound? initialRound;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // Game state
  var _teams = <TeamInfo>[];
  var _tableCards = <(String, String)>[];

  // Round state
  late ScopaRound _round;
  late String _currentPlayer;
  var _playerCards = <String, List<(String, String)>>{};
  var _playerFish = <String, List<(String, String)>>{};

  // UI state
  final _selectedCards = <(String, String)>[];
  final _winners = <TeamInfo>[];

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
          players: teams[i]
              .players
              .map((player) => PlayerInfo(player.name, _round.scopas[player]!))
              .toList(),
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
        setState(() {
          _winners.addAll(winners.map(
              (team) => _teams.singleWhere((info) => info.name == team.name)));
        });
        return;
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
          teamInfo.name.isNotEmpty == true || teamInfo.players.length > 1;
      if (isNotSinglePlayerUnnamedTeam) {
        teamsList.add(TeamCard(score: teamInfo.score, teamName: teamInfo.name));
      }
      teamsList.addAll(teamInfo.players.map((player) => PlayerCard(
            name: player.name,
            hand: _playerCards[player.name]!,
            fishes: _playerFish[player.name]!,
            teamScore: isNotSinglePlayerUnnamedTeam ? null : teamInfo.score,
            isCurrent: _currentPlayer == player.name,
            scopas: player.scopaCount,
          )));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scopa'),
      ),
      body: SafeArea(
          child: _winners.isEmpty
              ? Column(
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
                )
              : WinnerCard(teamScores: {})),
    );
  }
}
