import 'package:flutter/widgets.dart';
import 'package:scopa_lib/tabletop_lib.dart' as tabletop_lib;

class PlayerCard extends StatelessWidget {
  const PlayerCard(
      {super.key,
      required this.name,
      required this.hand,
      required this.fishes});

  final String name;
  final List<tabletop_lib.Card> hand;
  final List<tabletop_lib.Card> fishes;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
