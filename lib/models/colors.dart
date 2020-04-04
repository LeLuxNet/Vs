import 'package:flutter/material.dart';

class PlayerColors {
  static const PlayerColor red = PlayerColor(0, Colors.red);
  static const PlayerColor blue = PlayerColor(1, Colors.blue);
  static const PlayerColor green = PlayerColor(2, Colors.green);
  static const PlayerColor yellow = PlayerColor(3, Colors.yellow);

  static const PlayerColor white = PlayerColor(4, Colors.white);
  static const PlayerColor black = PlayerColor(5, Colors.black);

  static const PlayerColor orange = PlayerColor(6, Colors.orange);

  static const List<PlayerColor> fourColored = [
    PlayerColors.red,
    PlayerColors.blue,
    PlayerColors.green,
    PlayerColors.yellow
  ];
  static const List<PlayerColor> fourColoredWhiteOrange = [
    PlayerColors.red,
    PlayerColors.blue,
    PlayerColors.green,
    PlayerColors.yellow,
    PlayerColors.white,
    PlayerColors.orange
  ];
  static const List<PlayerColor> blackAndWhite = [
    PlayerColors.white,
    PlayerColors.black
  ];
}

class PlayerColor {
  final Color color;
  final int id;

  const PlayerColor(this.id, this.color);
}
