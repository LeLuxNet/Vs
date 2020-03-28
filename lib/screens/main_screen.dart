import 'package:flutter/material.dart';
import 'package:vs/models/counter.dart';
import 'package:vs/models/game.dart';
import 'package:vs/services/localization.dart';
import 'package:vs/services/store.dart';
import 'package:vs/widgets/counter.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<Game> _game;
  DataStore store;
  bool firstBuild = true;

  static final Choice _resetButton = Choice(title: 'reset');
  static final List<Choice> _popupMenuButtons = [_resetButton];

  @override
  void initState() {
    super.initState();
    store = new DataStore();
    _game = store.getGame();
  }

  void _selectPopupMenu(Choice choice) async {
    if (choice == _resetButton) {
      Game game = await _game;
      setState(() {
        game.reset();
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("appName")),
          actions: <Widget>[
            new FutureBuilder<Game>(
                future: _game,
                builder: (context, snapshot) {
                  return IconButton(
                      icon: Icon(Icons.add),
                      onPressed:
                          snapshot.hasData && snapshot.data.isAddCounter()
                              ? () => setState(snapshot.data.addCounter)
                              : null);
                }),
            new FutureBuilder<Game>(
                future: _game,
                builder: (context, snapshot) {
                  return IconButton(
                      icon: Icon(Icons.remove),
                      onPressed:
                          snapshot.hasData && snapshot.data.isRemoveCounter()
                              ? () => setState(snapshot.data.removeCounter)
                              : null);
                }),
            PopupMenuButton<Choice>(
              onSelected: _selectPopupMenu,
              itemBuilder: (BuildContext context) {
                return _popupMenuButtons.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(
                        AppLocalizations.of(context).translate(choice.title)),
                  );
                }).toList();
              },
            ),
          ],
        ),
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
  Choice({this.title});

  final String title;
}
