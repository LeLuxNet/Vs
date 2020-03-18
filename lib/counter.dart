import 'dart:developer';
import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:vs/localization.dart';

class Counter extends StatefulWidget {
  Color color;
  Function getter;
  Function setter;
  int position;
  bool animate;

  Counter(this.color, this.getter, this.setter, this.position, this.animate);

  @override
  State<StatefulWidget> createState() {
    return _CounterState();
  }
}

class _CounterState extends State<Counter> with TickerProviderStateMixin {
  bool visible = false;

  _setVisible() async {
    if (widget.animate) {
      Future.delayed(new Duration(milliseconds: (100 * widget.position)), () {
        setState(() => visible = true);
      });
    }
  }

  Widget getCard() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: widget.color,
        child: Listener(
          onPointerUp: (PointerUpEvent e) {
            // Detect if the left or the right side has been taped
            RenderBox box = context.findRenderObject();
            var percent = e.localPosition.dx / box.size.width;
            if (percent >= 0.5) {
              setState(() {
                widget.setter(widget.getter() + 1);
              });
            } else {
              setState(() {
                if (widget.getter() > 0) {
                  widget.setter(widget.getter() - 1);
                }
              });
            }
          },
          child: InkWell(
            onTap: () {},
            child: Center(
                child: Text(widget.getter().toString(),
                    style: TextStyle(color: Colors.white, fontSize: 50))),
          ),
        ),
      ),
    );
  }

  Widget getAnimation() {
    if (widget.animate) {
      return AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: Duration(milliseconds: 500),
          child: getCard());
    }
    return getCard();
  }

  @override
  Widget build(BuildContext context) {
    _setVisible();
    return Expanded(child: getAnimation());
  }
}
