import 'package:flutter/material.dart';
import 'package:scopa_app/player_card.dart';
import 'package:scopa_app/table_hand.dart';
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

  void _refreshGameState() {
    tableCards = List.unmodifiable(widget.game.table.round.cards);
    currentPlayer = currentRound.currentPlayer?.name;
    selectedHandCard = null;
    selectedTableCards = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Game')),
        body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, q) => [
                  SliverToBoxAdapter(
                      child: TableHand(
                    cards: tableCards,
                    selectedCards: selectedTableCards,
                    onCardTap: (card) {
                      setState(() {
                        if (selectedTableCards.contains(card)) {
                          selectedTableCards.remove(card);
                        } else {
                          selectedTableCards.add(card);
                        }
                      });
                    },
                    onCardDrop: (card) {
                      if (playerCards[currentPlayer]!.contains(card)) {
                        playerCards[currentPlayer]!.remove(card);

                        RoundState roundState;
                        if (selectedTableCards.isEmpty) {
                          roundState = currentRound.play(card);
                        } else {
                          // TODO: Validate selected cards can capture

                          playerFishes[currentPlayer]!.add(card);
                          playerFishes[currentPlayer]!
                              .addAll(selectedTableCards);

                          roundState =
                              currentRound.play(card, selectedTableCards);
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
                              playerCards[player.name]!.addAll(
                                  currentRound.playerHands[player]!.cards);
                            }
                            break;
                        }
                        _resetGameState();
                      }
                    },
                  ))
                ],
            body: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 500),
                itemCount: widget.game.teams.length,
                itemBuilder: ((context, index) {
                  final team = widget.game.teams[index];
                  return Card(
                      child: NestedScrollView(
                    floatHeaderSlivers: false,
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Text(
                            team.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.game.teamScores[team].toString()),
                        ]),
                      ))
                    ],
                    body: ListView.builder(
                      itemCount: team.players.length,
                      itemBuilder: (context, index) {
                        final player = team.players[index];
                        return PlayerCard(
                          name: player.name,
                          hand: playerCards[player.name]!,
                          fishes: playerFishes[player.name]!,
                          isCurrent: currentPlayer == player.name,
                          selectedHandCard: selectedHandCard,
                          onHandCardTap: (card) {
                            if (player.name == currentPlayer) {
                              setState(() {
                                selectedHandCard = card;
                              });
                            }
                          },
                        );
                      },
                    ),
                  ));
                }))));
  }
}
