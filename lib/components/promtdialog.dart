import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PromptDialog extends StatefulWidget {
  final String title;
  final String label;
  final Function callback;
  final String value;

  PromptDialog(this.title, this.label, this.callback, {this.value = ""});

  @override
  _PromptDialogState createState() => _PromptDialogState();
}

class _PromptDialogState extends State<PromptDialog> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = new TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: new TextField(
          decoration: new InputDecoration(labelText: widget.label),
          controller: _controller),
      actions: <Widget>[
        new FlatButton(
          child: new Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () => Navigator.pop(context),
        ),
        new FlatButton(
          child: new Text(MaterialLocalizations.of(context).okButtonLabel),
          onPressed: () {
            widget.callback(_controller.value.text);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
