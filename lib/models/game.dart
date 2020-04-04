import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vs/models/game_type.dart';
import 'package:vs/services/data_service.dart';
import 'package:vs/services/localization.dart';
import 'package:vs/services/service_locator.dart';

import 'colors.dart';
import 'counter.dart';

class Game extends ChangeNotifier {
  static final List<Color> colors = [
    PlayerColors.red.color,
    Colors.pink,
    Colors.purple,
    PlayerColors.blue.color,
    Colors.lightBlue[300],
    Colors.lime,
    PlayerColors.green.color,
    Colors.orange,
    PlayerColors.yellow.color,
    PlayerColors.white.color,
    PlayerColors.black.color
  ];

  int id;
  String name;
  List<Counter> counter;
  bool negativeAllowed;
  GameType gameType;

  static final Random _random = new Random();
  DataService _dataService = locator<DataService>();

  Game(this.id, this.name, this.counter, this.gameType, this.negativeAllowed);

  factory Game.fromMap(int id, Map map) {
    Game game = Game(id, map["name"] ?? "", [], GameType.list[map["gameType"] ?? 0],
        map["negativeAllowed"] ?? false);
    game.counter =
        map["counter"].map<Counter>((e) => Counter.fromMap(game, e)).toList();
    return game;
  }

  Game.simple() : this(-1, "", [], GameType.normal, false);

  String getName(AppLocalizations localizations) {
    if (name == "") {
      return localizations.translate("newGame") +
          (id == 1 ? "" : " (" + id.toString() + ")");
    }
    return name;
  }

  void setNegativeAllowed(bool value) {
    counter.forEach((e) {
      if (e.number < 0) {
        e.number = 0;
      }
    });
    negativeAllowed = value;
  }

  restart() {
    counter.forEach((c) => c.reset());
  }

  PlayerColor _generateColor() {
    List<PlayerColor> freeColors = [];
    freeColors.addAll(gameType.colors);
    counter.forEach((c) => freeColors.remove(c.color));
    return freeColors[_random.nextInt(freeColors.length)];
  }

  Counter _getCounter(int number) {
    return Counter(number, _generateColor(), this);
  }

  isAddCounter() {
    return counter.length < gameType.colors.length;
  }

  _addCounter(int number) {
    if (isAddCounter()) {
      Counter newCounter = _getCounter(number);
      counter.add(newCounter);
      notifyListeners();
      save();
    }
  }

  addCounter() {
    _addCounter(null);
  }

  bool isRemoveCounter() {
    // May some tests later
    return true;
  }

  removeCounter() {
    if (counter.length > 1) {
      counter.removeLast();
      notifyListeners();
      save();
    } else if (counter.length == 1) {
      Counter first = counter.first;
      first.color = _generateColor();
      first.reset();
    }
  }

  save() {
    _dataService.saveGame(this);
  }

  Future<Game> delete() {
    Future<Game> game = _dataService.deleteGame(id);
    notifyListeners();
    return game;
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "counter": counter.map((e) => e.toMap()),
      "gameType": GameType.list.indexOf(gameType),
      "negativeAllowed": negativeAllowed
    };
  }
}
