import 'package:flutter/material.dart';
import 'package:vs/services/data_service.dart';
import 'package:vs/services/localization.dart';
import 'package:vs/services/service_locator.dart';

import 'counter.dart';

class Game extends ChangeNotifier {
  static final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow
  ];

  int id;
  String name;
  List<Counter> counter;

  DataService _dataService = locator<DataService>();

  Game(this.id, this.name, this.counter);

  factory Game.fromMap(int id, Map map) {
    Game game = Game(id, map["name"], []);
    game.counter =
        map["counter"].map<Counter>((e) => Counter.fromMap(game, e)).toList();
    return game;
  }

  Game.simple() : this(-1, "", []);

  String getName(AppLocalizations localizations) {
    if (name == "") {
      return localizations.translate("newGame") +
          (id == 1 ? "" : " (" + id.toString() + ")");
    }
    return name;
  }

  restart() {
    counter.forEach((c) => c.reset());
  }

  Counter _getCounter() {
    return new Counter(0, colors[counter.length], this);
  }

  isAddCounter() {
    return counter.length < colors.length;
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
    return counter.length > 1 ||
        (counter.length == 1 && counter[0].number != 0);
  }

  removeCounter() {
    if (counter.length > 1) {
      counter.removeLast();
      notifyListeners();
      save();
    } else if (counter.length == 1) {
      counter.first.reset();
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
    return {"name": name, "counter": counter.map((e) => e.toMap())};
  }
}
