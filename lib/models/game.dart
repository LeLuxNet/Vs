import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vs/services/data_service.dart';
import 'package:vs/services/localization.dart';
import 'package:vs/services/service_locator.dart';

import 'counter.dart';

class Game extends ChangeNotifier {
  static final List<Color> colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.blue,
    Colors.lightBlue[300],
    Colors.lime,
    Colors.green,
    Colors.orange,
    Colors.yellow,
    Colors.white,
    Colors.black
  ];

  final int maxPlayers = 4;

  int id;
  String name;
  List<Counter> counter;
  bool negativeAllowed;

  DataService _dataService = locator<DataService>();

  Game(this.id, this.name, this.counter, this.negativeAllowed);

  factory Game.fromMap(int id, Map map) {
    Game game = Game(id, map["name"], [], map["negativeAllowed"] ?? false);
    game.counter =
        map["counter"].map<Counter>((e) => Counter.fromMap(game, e)).toList();
    return game;
  }

  Game.simple() : this(-1, "", [], false);

  String getName(AppLocalizations localizations) {
    if (name == "") {
      return localizations.translate("newGame") +
          (id == 1 ? "" : " (" + id.toString() + ")");
    }
    return name;
  }

  void setNegativeAllowed(bool value) {
    counter.forEach((e) {
      if(e.number < 0) {
        e.number = 0;
      }
    });
    negativeAllowed = value;
  }

  restart() {
    counter.forEach((c) => c.reset());
  }

  int _generateColor() {
    List<int> freeColors = [];
    for(int i = 0; i < colors.length; i++) {
      freeColors.add(i);
    }
    counter.forEach((c) => freeColors.remove(c.color));
    Random random = new Random();
    return freeColors[random.nextInt(freeColors.length)];
  }

  Counter _getCounter() {
    return new Counter(0, _generateColor(), this);
  }

  isAddCounter() {
    return counter.length < maxPlayers;
  }

  _addCounter(int number) {
    if (isAddCounter()) {
      Counter newCounter = _getCounter();
      newCounter.number = number;
      counter.add(newCounter);
      notifyListeners();
      save();
    }
  }

  addCounter() {
    _addCounter(0);
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
    return {"name": name, "counter": counter.map((e) => e.toMap()), "negativeAllowed": negativeAllowed};
  }
}
