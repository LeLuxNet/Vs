import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vs/models/counter.dart';
import 'package:vs/services/store.dart';
import 'package:vs/widgets/counter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vs/services/localization.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vs.',
      theme: ThemeData(primarySwatch: Colors.yellow),
      darkTheme: ThemeData.dark(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        const Locale('en'),
        const Locale('de'),
      ],
      home: MyHomePage(title: 'Vs.'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<GameData> _game;
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
      GameData game = await _game;
      setState(() {
        game.reset();
      });
    }
  }

  Widget _getCounterWidget(CounterData data, int id) {
    return new CounterWidget(data, id, firstBuild);
  }

  List<Widget> _getCounterCards(GameData game) {
    List<Widget> list = [];
    for (int i = 0; i < game.counter.length; i++) {
      list.add(_getCounterWidget(game.counter[i], i));
    }
    if(firstBuild) {
      firstBuild = false;
    }
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
          title: Text(widget.title),
          actions: <Widget>[
            new FutureBuilder<GameData>(
                future: _game,
                builder: (context, snapshot) {
                  return IconButton(
                      icon: Icon(Icons.add),
                      onPressed:
                          snapshot.hasData && snapshot.data.isAddCounter()
                              ? () => setState(snapshot.data.addCounter)
                              : null);
                }),
            new FutureBuilder<GameData>(
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
        body: new FutureBuilder<GameData>(
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
  const Choice({this.title});

  final String title;
}
