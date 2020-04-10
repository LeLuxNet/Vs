import 'package:vs/models/game.dart';
import 'package:vs/models/settings.dart';

abstract class DataService {

  Future<Game> getGame(int id);

  Future<List<Game>> getGames();

  Future<Game> createGame();

  Future<Game> deleteGame(int id);

  saveGame(Game game);

  setLastOpenGameId(int id);

  saveSettings(Settings settings);

  Future<Settings> getSettings();
}