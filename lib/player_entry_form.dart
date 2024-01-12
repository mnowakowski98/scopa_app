import 'package:flutter/material.dart';
import 'package:scopa_app/teams_list_dropdown.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class PlayerEntryForm extends StatefulWidget {
  const PlayerEntryForm({super.key, this.onAdd, this.teams});

  final Function(Player player, Team team)? onAdd;
  final List<Team>? teams;

  @override
  State<PlayerEntryForm> createState() => _PlayerEntryFormState();
}

class _PlayerEntryFormState extends State<PlayerEntryForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  Team? _selectedTeam;

  void selectTeam(Team team) {
    setState(() {
      _selectedTeam = team;
    });
  }

  @override
  void initState() {
    if (widget.teams != null && widget.teams!.isNotEmpty) {
      _selectedTeam = widget.teams!.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Player name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() == false) return;
                        final text = _textController.text;
                        _textController.clear();

                        if (widget.onAdd != null && _selectedTeam != null) {
                          widget.onAdd!(Player(text), _selectedTeam!);
                        }
                      },
                      child: const Text('Add')),
                ),
              ],
            ),
            if (widget.teams != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TeamsListDropdown(
                    onTeamSelected: selectTeam,
                    label: 'Add to team',
                    teams: widget.teams!),
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
