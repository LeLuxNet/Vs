import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vs/components/counter.dart';
import 'package:vs/components/drawer.dart';
import 'package:vs/models/counter.dart';
import 'package:vs/models/game.dart';
import 'package:vs/services/localization.dart';
import 'package:vs/services/store.dart';

class MainScreen extends StatefulWidget {
  int id;

  MainScreen(this.id);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<Game> _game;
  DataStore store;

  bool firstBuild = true;
  String _title = "";

  Choice _resetButton;
  Choice _settingsButton;
  List<Choice> _popupMenuButtons;

  @override
  void initState() {
    store = new DataStore();

    print("GameId: " + widget.id.toString());

    if (widget.id == null) {
      widget.id = 1;
    }

    _game = store.getGame(widget.id, true);

    _game.then((value) => setState(() => _title = value.name));

    _resetButton = Choice(
        title: 'reset',
        onSelect: () async {
          Game game = await _game;
          setState(() {
            game.reset();
          });
        });
    _settingsButton = Choice(
        title: 'settings',
        onSelect: () => Navigator.pushNamed(context, '/settings'));
    _popupMenuButtons = [_resetButton, _settingsButton];
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
        future: _game,
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
        drawer: DrawerWidget(store),
        body: new FutureBuilder<Game>(
            future: _game,
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
