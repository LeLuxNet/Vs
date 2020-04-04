import 'package:flutter/material.dart';
import 'package:vs/models/gametype/colors.dart';

import 'game.dart';

class Counter {
  int number;
  PlayerColor color;
  Game game;

  Counter(number, this.color, this.game) {
    if(number == null) {
      this.number = this.game.gameType.startNumber;
    } else {
      this.number = number;
    }
  }

  Counter.fromMap(Game game, Map map)
      : this(
            map["number"] ?? game.gameType.startNumber,
            // Backwards compatibility to version 0.2.1
            game.gameType
                .colors[map["color"] >= game.gameType.colors.length
                ? 0
                : map["color"]],
            game);

  add() {
    number++;
    game.save();
  }

  remove() {
    if (game.negativeAllowed || number > 0) {
      number--;
      game.save();
    }
  }

  Color getColor() {
    return color.color;
  }

  reset() {
    number = game.gameType.startNumber;
  }

  Map<String, dynamic> toMap() {
    return {"number": number, "color": color.id};
  }
}
