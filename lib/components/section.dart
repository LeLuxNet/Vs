import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String title;
  final Color color;
  final Widget child;

  Section(this.title, this.child, {this.color});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.all(16),
          child: Text(title,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold))),
      child
    ]);
  }
}
