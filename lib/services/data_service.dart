import 'package:vs/models/game.dart';

abstract class DataService {

  Future<Game> getGame(int id);

  Future<List<Game>> getGames();

  Future<Game> createGame();

  Future<Game> deleteGame(int id);

  saveGame(Game game);

  setLastOpenGameId(int id);

}