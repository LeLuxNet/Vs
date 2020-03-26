import 'package:flutter/material.dart';
import 'package:vs/services/store.dart';

class CounterData {
  int number = 0;
  Color color;
  GameData game;

  CounterData(this.color, this.game);

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

class GameData {
  static final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow
  ];

  List<CounterData> counter;
  DataStore store;

  GameData(store, counter) {
    this.store = store;
    this.counter = counter;
  }
  GameData.raw(store, List<int> data) {
    this.store = store;
    this.counter = [];
    for(int i in data) {
      _addCounter(i);
    }
  }

  reset() {
    counter = [];
    addCounter();
  }

  isAddCounter() {
    return counter.length < colors.length;
  }

  addCounter() {
    _addCounter(0);
  }

  _addCounter(int number) {
    if (isAddCounter()) {
      // TODO: firstbuild = false
      CounterData newCounter = new CounterData(colors[counter.length], this);
      newCounter.number = number;
      counter.add(newCounter);
      save();
    }
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
    store.saveGame(this);
  }
}
