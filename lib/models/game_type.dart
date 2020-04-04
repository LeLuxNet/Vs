import 'package:vs/models/colors.dart';

class GameType {

  static const GameType normal = GameType("normal", PlayerColors.fourColored);
  // static const GameType blackAndWhite = GameType("blackAndWhite", PlayerColors.blackAndWhite);

  static const GameType catan = GameType("catan", PlayerColors.fourColored);
  static const GameType life = GameType("life", PlayerColors.fourColoredWhiteOrange, startNumber: 1000);

  static const List<GameType> list = [
    normal, catan, life
  ];

  final String name;
  final List<PlayerColor> colors;
  final int startNumber;

  const GameType(this.name, this.colors, {this.startNumber = 0});

  String getI18nName() {
    return "gameType_" + name;
  }
}