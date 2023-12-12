import 'package:flutter/material.dart';
import 'package:scopa_app/player_card.dart';
import 'package:scopa_app/table_hand.dart';
import 'package:scopa_app/team_card.dart';
import 'package:scopa_app/winner_card.dart';
import 'package:scopa_lib/scopa_lib.dart';
import 'package:scopa_lib/tabletop_lib.dart' as tabletop_lib;

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.game});

  final Game game;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late ScopaRound currentRound;
  late List<tabletop_lib.Card> tableCards;
  late List<tabletop_lib.Card> selectedTableCards;
  Iterable<tabletop_lib.Team> winningTeams = [];

  final playerCards = <String, List<tabletop_lib.Card>>{};
  final playerFishes = <String, List<tabletop_lib.Card>>{};
  final playerScopas = <String, int>{};

  tabletop_lib.Card? selectedHandCard;

  String? currentPlayer;
  final teamsList = <Widget>[];

  List<Widget> _buildTeamsList(
      List<tabletop_lib.Team> teams, Map<tabletop_lib.Team, int> teamScores) {
    teamsList.clear();
    for (final team in teams) {
      teamsList.add(TeamCard(team: team, score: teamScores[team]!));
      teamsList.addAll([
        for (final player in team.players)
          PlayerCard(
            name: player.name,
            hand: playerCards[player.name]!,
            fishes: playerFishes[player.name]!,
            scopas: playerScopas[player.name]!,
            isCurrent: currentPlayer == player.name,
          )
      ]);
    }
    return teamsList;
  }

  void _refreshGameState() {
    tableCards = List.unmodifiable(widget.game.table.round.cards);
    currentPlayer = currentRound.currentPlayer?.name;
    selectedHandCard = null;
    selectedTableCards = [];

    for (final seat in widget.game.table.seats) {
      final player = seat.player!;
      playerCards[player.name] = currentRound.playerHands[player]!.cards;
      playerFishes[player.name] = currentRound.captureHands[player]!.cards;
      playerScopas[player.name] = currentRound.scopas[player]!;
    }

    _buildTeamsList(widget.game.teams, widget.game.teamScores);
  }

  void _resetGameState() {
    setState(() {
      _refreshGameState();
    });
  }

  @override
  void initState() {
    super.initState();
    currentRound = widget.game.nextRound();
    _refreshGameState();
  }

  void _selectTableCard(tabletop_lib.Card card) {
    setState(() {
      if (selectedTableCards.contains(card)) {
        selectedTableCards.remove(card);
      } else {
        selectedTableCards.add(card);
      }
    });
  }

  void _playCard(tabletop_lib.Card card, List<tabletop_lib.Card> matchCards) {
    if (currentRound.validatePlay(card, matchCards) == false) return;

    bool roundState;
    if (matchCards.isEmpty) {
      roundState = currentRound.play(card);
    } else {
      roundState = currentRound.play(card, matchCards);
    }

    // TODO: Find a way to rig deck to test this half of the function.
    if (roundState == false) {
      final winners = widget.game.scoreRound(currentRound);
      if (winners != null && winners.isNotEmpty) {
        setState(() {
          winningTeams = winners;
        });
        return;
      }

      currentRound = widget.game.nextRound();
      for (final seat in widget.game.table.seats) {
        final player = seat.player!;
        playerCards[player.name]!
            .addAll(currentRound.playerHands[player]!.cards);
      }
    }
    _resetGameState();
  }

  @override
  Widget build(BuildContext context) {
    final winCard = Center(
      child: WinnerCard(
          teamScores: Map.fromEntries(widget.game.teamScores.entries
              .where((element) => winningTeams.contains(element.key)))),
    );

    return Scaffold(
        appBar: AppBar(title: const Text('Game')),
        body: winningTeams.isEmpty
            ? Column(
                children: [
                  Expanded(
                    child: TableHand(
                      cards: tableCards,
                      selectedCards: selectedTableCards,
                      onCardTap: _selectTableCard,
                      onCardDrop: (card) => _playCard(card, selectedTableCards),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: ListView.builder(
                      itemCount: teamsList.length,
                      itemBuilder: (context, index) => teamsList[index],
                    ),
                  ),
                ],
              )
            : winCard);
  }
}
