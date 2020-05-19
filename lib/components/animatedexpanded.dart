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

class _AnimatedExpandedState extends State<AnimatedExpanded>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(
            duration: const Duration(milliseconds: 400), vsync: this);
    _controller.forward();
    _animation = IntTween(begin: 1, end: widget.steps).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: _animation.value, child: widget.child);
  }
}
