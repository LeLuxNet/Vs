import 'package:flutter/material.dart';

import 'game.dart';

class Counter {
  int number = 0;
  Color color;
  Game game;

  Counter(this.color, this.game);

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
}
