import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vs/models/gametype/colors.dart';

import '../game.dart';

class GameType {
  static const GameType normal = GameType("normal", PlayerColors.fourColored);

  static const GameType catan =
  GameType("catan", PlayerColors.fourColored, icon: MdiIcons.barley);
  static const GameType life = GameType(
      "life", PlayerColors.fourColoredWhiteOrange,
      icon: Icons.child_friendly, startNumber: 1000);
  static const GameType tableTennis = GameType(
      "tableTennis", PlayerColors.fourColored,
      icon: MdiIcons.tableTennis, winner: tableTennisWinner);

  static const List<GameType> list = [normal, catan, life, tableTennis];

  static int returnNull(Game game) {
    return null;
  }

  static int tableTennisWinner(Game game) {
    if (game.counter.length == 1) {
      return 0;
    }

    // The highest
    int max = 0;
    int maxId = -1;

    // The 2. highest
    int high = 0;

    game.counter.asMap().forEach((i, c) {
      if (c.number > max) {
        high = max;
        max = c.number;
        maxId = i;
      } else if (c.number > high) {
        high = c.number;
      }
    });

    if (max >= 11 && max - high >= 2) {
      return maxId;
    }
    return null;
  }

  final String name;
  final List<PlayerColor> colors;
  final IconData icon;
  final int startNumber;
  final Function winner;

  const GameType(this.name, this.colors,
      {this.icon = MdiIcons.dice3,
        this.startNumber = 0,
        this.winner = returnNull});

  String getI18nName() {
    return "gameType_" + name;
  }
}
