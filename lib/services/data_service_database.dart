import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:vs/models/game.dart';
import 'package:vs/models/settings.dart';
import 'package:vs/services/data_service.dart';

class DataServiceDatabase extends DataService {

  static final String dbFile = "data.db";
  static final DatabaseFactory dbFactory = databaseFactoryIo;

  static final String gameStoreName = "games";

  static final String lastOpenGameRecordName = "lastOpenGame";
  static final String settingsRecordName = "settings";

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

  @override
  Future<Game> createGame() async {
    var store = intMapStoreFactory.store(gameStoreName);
    Database db = await _getInstance();
    Game game = Game.simple();
    game.id = await store.add(db, game.toMap());
    game.save();
    return game;
  }

  @override
  Future<Game> deleteGame(int id) async {
    var store = intMapStoreFactory.store(gameStoreName);
    Database db = await _getInstance();
    await store.record(id).delete(db);
    int newId = await _calculateGameId();
    return await getGame(newId);
  }

  @override
  Future<Game> getGame(int id) async {
    if (id == null) {
      id = await _getLastOpenGameId();
    }
    var store = intMapStoreFactory.store(gameStoreName);
    Database db = await _getInstance();
    Map map = await store.record(id).get(db);
    return Game.fromMap(id, map);
  }

  @override
  Future<List<Game>> getGames() async {
    var store = intMapStoreFactory.store(gameStoreName);
    Database db = await _getInstance();
    List<int> keys = await store.findKeys(db);
    return Future.wait(keys.map((e) => getGame(e)).toList());
  }

  @override
  saveGame(Game game) async {
    var store = intMapStoreFactory.store(gameStoreName);
    Database db = await _getInstance();
    await store.record(game.id).put(db, game.toMap());
  }

  Future<int> _getLastOpenGameId() async {
    var store = StoreRef.main();
    Database db = await _getInstance();
    int id = await store.record(lastOpenGameRecordName).get(db);
    if (id == null) {
      id = await _calculateGameId();
    }
    return id;
  }

  Future<int> _calculateGameId() async {
    List<Game> games = await getGames();
    int id;
    if (games.length == 0) {
      Game game = await createGame();
      id = game.id;
    } else {
      id = games.first.id;
    }
    await setLastOpenGameId(id);
    return id;
  }

  @override
  setLastOpenGameId(int id) async {
    var store = StoreRef.main();
    Database db = await _getInstance();
    await store.record(lastOpenGameRecordName).put(db, id);
    print("Last Game: $id");
  }

  @override
  saveSettings(Settings settings) async {
    var store = StoreRef.main();
    Database db = await _getInstance();
    await store.record(settingsRecordName).put(db, settings.toMap());
  }

  @override
  Future<Settings> getSettings() async {
    var store = StoreRef.main();
    Database db = await _getInstance();
    Map map = await store.record(settingsRecordName).get(db);
    return map == null ? Settings.simple() : Settings.fromMap(map);
  }
}