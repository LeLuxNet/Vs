import 'package:flutter/material.dart';

import 'game.dart';

class Counter {
  int number;
  int color;
  Game game;

  Counter(this.number, this.color, this.game);

  Counter.fromMap(Game game, Map map)
      : this(
            map["number"],
            // Backward compatible
            map["color"] > Game.colors.length
                ? Game.colors.indexWhere((e) => e.value == map["color"])
                : map["color"],
            game);

  add() {
    number++;
    game.save();
  }

  remove() {
    if (number > 0 || game.negativeAllowed) {
      number--;
      game.save();
    }
  }

  getColor() {
    print(color);
    return Game.colors[color];
  }

  reset() {
    number = 0;
  }

  Map<String, dynamic> toMap() {
    return {"number": number, "color": color};
  }
}
