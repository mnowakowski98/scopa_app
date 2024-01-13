import 'package:flutter/material.dart';
import 'package:scopa_lib/tabletop_lib.dart';

class PlayerEntryForm extends StatefulWidget {
  const PlayerEntryForm({
    super.key,
    this.onAdd,
    required this.teamName,
  });

  final Function(String playerName, String teamName)? onAdd;
  final String teamName;

  @override
  State<PlayerEntryForm> createState() => _PlayerEntryFormState();
}

class _PlayerEntryFormState extends State<PlayerEntryForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textField = TextFormField(
      textAlign: TextAlign.center,
      controller: _textController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      decoration: const InputDecoration(hintText: 'Player name'),
    );

    final button = ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate() == false) return;
          final text = _textController.text;
          _textController.clear();

          if (widget.onAdd != null) {
            widget.onAdd!(text, widget.teamName);
          }
        },
        child: const Text('Add'));

    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(builder: (context, contraints) {
              if (contraints.maxWidth <= 300) {
                return Column(
                  children: [
                    textField,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: button,
                    )
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: textField),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: button,
                  )
                ],
              );
            })
          ],
        ));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
