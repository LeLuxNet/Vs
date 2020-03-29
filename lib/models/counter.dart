import 'package:flutter/material.dart';

import 'game.dart';

class Counter {
  int number;
  Color color;
  Game game;

  Counter(this.number, this.color, this.game);

  Counter.fromMap(Game game, Map map)
      : this(map["number"], Color(map["color"]), game);

  add() {
    number++;
    game.save();
  }

  remove() {
    if (number > 0) {
      number--;
      game.save();
    }
  }

  reset() {
    number = 0;
  }

  Map<String, dynamic> toMap() {
    return {"number": number, "color": color.value};
  }
}
