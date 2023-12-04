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
  late Map<String, List<tabletop_lib.Card>> playerCards;
  late Map<String, List<tabletop_lib.Card>> playerFishes;

  tabletop_lib.Card? selectedHandCard;

  String? currentPlayer;

  void _refreshGameState() {
    tableCards = List.unmodifiable(widget.game.table.round.cards);
    playerCards = Map.unmodifiable(currentRound.playerHands
        .map((key, value) => MapEntry(key.name, value.cards)));
    playerFishes = Map.unmodifiable(currentRound.captureHands
        .map((key, value) => MapEntry(key.name, value.cards)));
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
    _refreshGameState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Game')),
        body: NestedScrollView(
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
                        currentRound.play(card);
                      }
                      _resetGameState();
                    },
                  ))
                ],
            body: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: widget.game.teams.length,
                itemBuilder: ((context, index) {
                  final team = widget.game.teams[index];
                  return Card(
                      child: NestedScrollView(
                    floatHeaderSlivers: true,
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Text(
                            team.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text('[team.score]'),
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
