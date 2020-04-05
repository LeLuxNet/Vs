import 'package:flutter/cupertino.dart';

class AnimatedExpanded extends StatefulWidget {
  final Widget child;
  final int steps;
  final Curve curve;

  AnimatedExpanded(
      {this.child, this.steps = 100, this.curve = Curves.easeInOut});

  @override
  _AnimatedExpandedState createState() => _AnimatedExpandedState();
}

class _AnimatedExpandedState extends State<AnimatedExpanded> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        tween: IntTween(begin: 1, end: widget.steps),
        curve: widget.curve,
        duration: const Duration(milliseconds: 500),
        builder: (_, int value, __) =>
            Expanded(flex: value, child: widget.child));
  }
}
