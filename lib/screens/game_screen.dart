import 'package:flutter/material.dart';
import 'package:vs/components/counter.dart';
import 'package:vs/components/drawer.dart';
import 'package:vs/models/counter.dart';
import 'package:vs/models/game.dart';
import 'package:vs/screens/game_settings_screen.dart';
import 'package:vs/screens/settings_screen.dart';
import 'package:vs/services/data_service.dart';
import 'package:vs/services/localization.dart';
import 'package:vs/services/service_locator.dart';

class GameScreen extends StatefulWidget {
  static final String navigationName = "/game";

  Future<Game> game;

  GameScreen(this.game);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool firstBuild = true;
  String _title = "";

  Choice _editButton;
  Choice _settingsButton;
  List<Choice> _popupMenuButtons;

  DataService _dataService = locator<DataService>();

  @override
  void initState() {
    if (widget.game == null) {
      widget.game = _dataService.getGame(null);
    }

    widget.game.then((value) {
      if (value.counter.length == 0) {
        Navigator.pushReplacementNamed(
            context, GameSettingsScreen.navigationName,
            arguments: {"game": value, "new": true});
      }
      setState(() => _title = value.getName(AppLocalizations.of(context)));
      _dataService.setLastOpenGameId(value.id);
      print("GameId: " + value.id.toString());
    });

    _editButton = Choice(
        title: 'editGame',
        onSelect: () async {
          Game game = await widget.game;
          Navigator.pushNamed(context, GameSettingsScreen.navigationName,
              arguments: {"game": game, "new": false});
        });
    _settingsButton = Choice(
        title: 'settings',
        onSelect: () =>
            Navigator.pushNamed(context, SettingsScreen.navigationName));
    _popupMenuButtons = [_editButton, _settingsButton];
    super.initState();
  }

  _getPopupMenu() {
    return PopupMenuButton<Choice>(
      onSelected: (choice) => choice.onSelect(),
      itemBuilder: (BuildContext context) {
        return _popupMenuButtons.map((Choice choice) {
          return PopupMenuItem<Choice>(
            value: choice,
            child: Text(AppLocalizations.of(context).translate(choice.title)),
          );
        }).toList();
      },
    );
  }

  Widget _getCounterWidget(Counter data, int id) {
    return new CounterWidget(data, id, firstBuild);
  }

  List<Widget> _getCounterCards(Game game) {
    List<Widget> list = [];
    for (int i = 0; i < game.counter.length; i++) {
      list.add(_getCounterWidget(game.counter[i], i));
    }
    firstBuild = false;
    return list;
  }

  Widget _getOrientationBasedWidget(List<Widget> children) {
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    if (currentOrientation == Orientation.portrait) {
      return new Column(children: children);
    } else {
      return new Row(children: children);
    }
  }

  Widget _getAppBarIcon(bool add) {
    return new FutureBuilder<Game>(
        future: widget.game,
        builder: (context, snapshot) {
          return IconButton(
              icon: Icon(add ? Icons.add : Icons.remove),
              onPressed: () {
                if (snapshot.hasData) {
                  if (add
                      ? snapshot.data.isAddCounter()
                      : snapshot.data.isRemoveCounter()) {
                    return add
                        ? () => setState(snapshot.data.addCounter)
                        : () => setState(snapshot.data.removeCounter);
                  }
                }
                return null;
              }());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
          actions: <Widget>[
            _getAppBarIcon(true),
            _getAppBarIcon(false),
            _getPopupMenu()
          ],
        ),
        drawer: DrawerWidget(),
        body: new FutureBuilder<Game>(
            future: widget.game,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _getOrientationBasedWidget(
                    _getCounterCards(snapshot.data));
              }
              return Container();
            }));
  }
}

class Choice {
  Choice({this.title, this.onSelect});

  final String title;
  final Function onSelect;
}
