import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vs/models/counter.dart';

class DataStore {
  static final String settingsKeyPrefix = "settings_";
  static final String counterKey = "counter";

  Future<SharedPreferences> _getInstance() async {
    return await SharedPreferences.getInstance();
  }

  Future<GameData> getGame() async {
    SharedPreferences preferences = await _getInstance();
    List<String> raw = preferences.getStringList(counterKey) ?? ["0"];
    return GameData.raw(this, raw.map((e) => int.parse(e)).toList());
  }

  Future<void> saveGame(GameData game) async {
    SharedPreferences preferences = await _getInstance();
    preferences.setStringList(
        counterKey, game.counter.map((e) => e.number.toString()).toList());
  }
}
