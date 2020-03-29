import 'package:flutter/material.dart';
import 'package:vs/services/store.dart';

import 'counter.dart';

class Game {
  static final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow
  ];

  int id;
  String name;
  List<Counter> counter;
  DataStore _store;

  Game(this.id, this.name, this._store, this.counter);

  factory Game.fromMap(int id, DataStore store, Map map) {
    Game game = Game(id, map["name"], store, []);
    game.counter =
        map["counter"].map<Counter>((e) => Counter.fromMap(game, e)).toList();
    return game;
  }

  Game.simple(DataStore store) : this(-1, "", store, []);

  reset() {
    counter = [];
    addCounter();
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
      save();
    } else if (counter.length == 1) {
      reset();
    }
  }

  save() {
    _store.saveGame(this);
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "counter": counter.map((e) => e.toMap())};
  }
}
