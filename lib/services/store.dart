import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:vs/models/game.dart';
import 'package:vs/services/localization.dart';

class DataStore {
  static final String dbFile = "data.db";
  static final DatabaseFactory dbFactory = databaseFactoryIo;

  static final String gameStoreName = "games";

  Database _db;

  Future<Database> _getInstance() async {
    if (_db == null) {
      Directory dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      String dbPath = join(dir.path, dbFile);
      _db = await dbFactory.openDatabase(dbPath);
    }
    return _db;
  }

  Future<Game> getGame(int id, bool setLast) async {
    if (id == null) {
      id = await _getLastOpenGameId();
    } else if (setLast) {
      _setLastOpenGameId(id);
    }
    var store = intMapStoreFactory.store(gameStoreName);
    Database db = await _getInstance();
    Map map = await store.record(id).get(db);
    return Game.fromMap(id, this, map);
  }

  Future<List<Game>> getGames() async {
    var store = intMapStoreFactory.store(gameStoreName);
    Database db = await _getInstance();
    List<int> keys = await store.findKeys(db);
    return Future.wait(keys.map((e) => getGame(e, false)).toList());
  }

  Future<Game> createGame(BuildContext context) async {
    var store = intMapStoreFactory.store(gameStoreName);
    Database db = await _getInstance();
    Game game = Game.simple(this);
    game.id = await store.add(db, game.toMap());
    game.name = AppLocalizations.of(context).translate("newGame") + " (" + game.id.toString() + ")";
    game.addCounter();
    return game;
  }

  saveGame(Game game) async {
    var store = intMapStoreFactory.store(gameStoreName);
    Database db = await _getInstance();
    await store.record(game.id).put(db, game.toMap());
  }

  Future<int> _getLastOpenGameId() async {
    var store = StoreRef.main();
    Database db = await _getInstance();
    int id = await store.record("lastOpenGame").get(db);
    if (id == null) {
      List<Game> games = await getGames();
      id = games.first.id;
      _setLastOpenGameId(id);
    }
    return id;
  }

  _setLastOpenGameId(int id) async {
    var store = StoreRef.main();
    Database db = await _getInstance();
    await store.record("lastOpenGame").put(db, id);
  }
}
