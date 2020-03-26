import 'package:flutter/material.dart';
import 'package:vs/models/counter.dart';

class CounterWidget extends StatefulWidget {
  CounterData data;
  int position;
  bool animate;

  CounterWidget(this.data, this.position, this.animate);

  @override
  State<StatefulWidget> createState() {
    return _CounterWidgetState();
  }
}

class _CounterWidgetState extends State<CounterWidget> with TickerProviderStateMixin {
  bool visible = false;

  _setVisible() async {
    if (widget.animate && !visible) {
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
        color: widget.data.color,
        child: Listener(
          onPointerUp: (PointerUpEvent e) {
            // Detect if the left or the right side has been taped
            RenderBox box = context.findRenderObject();
            var percent = e.localPosition.dx / box.size.width;
            if (percent >= 0.5) {
              setState(() {
                widget.data.add();
              });
            } else {
              setState(() {
                widget.data.remove();
              });
            }
          },
          child: InkWell(
            onTap: () {},
            child: Center(
                child: Text(widget.data.number.toString(),
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
