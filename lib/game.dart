import 'package:flutter/material.dart';
import 'package:scopa_app/player_card.dart';
import 'package:scopa_app/table_hand.dart';
import 'package:scopa_app/team_card.dart';
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

  final playerCards = <String, List<tabletop_lib.Card>>{};
  final playerFishes = <String, List<tabletop_lib.Card>>{};
  final playerScopas = <String, List<List<tabletop_lib.Card>>>{};

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
            scopas: playerScopas[player.name]!.length,
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

    for (final seat in widget.game.table.seats) {
      final player = seat.player!;
      playerCards[player.name] = currentRound.playerHands[player]!.cards;
      playerFishes[player.name] = currentRound.captureHands[player]!.cards;
      playerScopas[player.name] = [];
    }

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
    playerCards[currentPlayer]!.remove(card);

    RoundState roundState;
    if (matchCards.isEmpty) {
      roundState = currentRound.play(card);
    } else {
      // TODO: Validate selected cards can capture

      playerFishes[currentPlayer]!.add(card);
      playerFishes[currentPlayer]!.addAll(matchCards);

      roundState = currentRound.play(card, matchCards);
    }

    switch (roundState) {
      case RoundState.next:
        break;
      case RoundState.scopa:
        final scopaCards = <tabletop_lib.Card>[];
        scopaCards.add(card);
        scopaCards.addAll(selectedTableCards);
        playerScopas[currentPlayer]!.add(scopaCards);
        break;
      case RoundState.ending:
        widget.game.scoreRound(currentRound);
        currentRound = widget.game.nextRound();
        for (final seat in widget.game.table.seats) {
          final player = seat.player!;
          playerCards[player.name]!
              .addAll(currentRound.playerHands[player]!.cards);
        }
        break;
    }
    _resetGameState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Game')),
        body: Column(
          children: [
            Expanded(
              child: TableHand(
                cards: tableCards,
                selectedCards: selectedTableCards,
                onCardTap: _selectTableCard,
                onCardDrop: (card) {
                  if (playerCards[currentPlayer]!.contains(card)) {
                    _playCard(card, selectedTableCards);
                  }
                },
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
        ));
  }
}
