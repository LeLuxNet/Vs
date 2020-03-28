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

  List<Counter> counter;
  DataStore store;

  Game(store, counter) {
    this.store = store;
    this.counter = counter;
  }

  Game.raw(store, List<int> data) {
    this.store = store;
    this.counter = [];
    for (int i in data) {
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
      Counter newCounter = new Counter(colors[counter.length], this);
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
