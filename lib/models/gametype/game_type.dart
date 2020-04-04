import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vs/models/gametype/colors.dart';

class GameType {
  static const GameType normal = GameType("normal", PlayerColors.fourColored);

  static const GameType catan = GameType(
      "catan", PlayerColors.fourColored, icon: MdiIcons.barley);
  static const GameType life = GameType(
      "life", PlayerColors.fourColoredWhiteOrange,
      icon: Icons.child_friendly, startNumber: 1000);

  static const List<GameType> list = [normal, catan, life];

  final String name;
  final List<PlayerColor> colors;
  final IconData icon;
  final int startNumber;

  const GameType(this.name, this.colors,
      {this.icon = MdiIcons.dice3, this.startNumber = 0});

  String getI18nName() {
    return "gameType_" + name;
  }
}
