import 'package:flutter/material.dart';
import 'package:scopa_app/teams_list_dropdown.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class PlayerEntryForm extends StatefulWidget {
  const PlayerEntryForm({super.key, this.onAdd, this.teams});

  final Function(Player player)? onAdd;
  final List<Team>? teams;

  @override
  State<PlayerEntryForm> createState() => _PlayerEntryFormState();
}

class _PlayerEntryFormState extends State<PlayerEntryForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _textController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(hintText: 'Player name'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() == false) return;
                        final text = _textController.text;
                        _textController.clear();

                        if (widget.onAdd != null) {
                          widget.onAdd!(Player(text));
                        }
                      },
                      child: const Text('Add')),
                ),
              ],
            ),
            Row(
              children: [
                if (widget.teams != null)
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TeamsListDropdown(teams: widget.teams!),
                  )),
              ],
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
