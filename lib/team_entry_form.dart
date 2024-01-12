import 'package:flutter/material.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class TeamEntryForm extends StatefulWidget {
  const TeamEntryForm({super.key, this.onAdd});

  final void Function(Team team)? onAdd;

  @override
  State<TeamEntryForm> createState() => _TeamEntryFormState();
}

class _TeamEntryFormState extends State<TeamEntryForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
                child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a value";
                }
                return null;
              },
              decoration: const InputDecoration(hintText: 'Team name'),
              controller: _textController,
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() == false) return;
                    final text = _textController.text;
                    _textController.clear();
                    if (widget.onAdd != null) {
                      widget.onAdd!(Team.players([], name: text));
                    }
                  },
                  child: const Text('Add')),
            )
          ],
        ));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
