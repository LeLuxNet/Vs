import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vs/counter.dart';
import 'package:vs/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vs.',
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.yellow,
          accentColor: Colors.yellowAccent),
      darkTheme: ThemeData(
          brightness: Brightness.dark, accentColor: Colors.yellowAccent),
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
  List<int> _counter = [0];
  SharedPreferences preferences;
  bool firstBuild = true;

  static final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow
  ];
  static final Choice _resetButton = Choice(title: 'reset');
  static final List<Choice> _popupMenuButtons = [_resetButton];
  static final String _key = 'counter';

  void reset() {
    setState(() => _counter = [0]);
    _save();
  }

  void _addCounter() {
    firstBuild = false;
    if (_counter.length < _colors.length) {
      setState(() => _counter.add(0));
      _save();
    }
  }

  void _removeCounter() {
    if (_counter.length > 1) {
      setState(() => _counter.removeLast());
      _save();
    } else if (_counter.length == 1) {
      setState(() => _counter[0] = 0);
      _save();
    }
  }

  Future _load() async {
    preferences = await SharedPreferences.getInstance();
    await _read();
    return Future.value("Loaded");
  }

  _read() async {
    List<String> rawList = (preferences.getStringList(_key) ?? List<String>());
    setState(() => _counter = rawList.map((i) => int.parse(i)).toList());
  }

  _save() async {
    preferences.setStringList(_key, _counter.map((i) => i.toString()).toList());
  }

  void _selectPopupMenu(Choice choice) {
    if (choice == _resetButton) {
      reset();
    }
  }

  Widget _getCounterWidget(Color color, int id) {
    return new Counter(color, () => _counter[id], (v) {
      _counter[id] = v;
      _save();
    }, id, firstBuild);
  }

  List<Widget> _getCounterCards() {
    List<Widget> list = [];
    for (int i = 0; i < _counter.length; i++) {
      list.add(_getCounterWidget(_colors[i], i));
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed:
                _counter.length < _colors.length ? _addCounter : null),
            IconButton(
                icon: Icon(Icons.remove),
                onPressed: (_counter.length > 1 || _counter[0] != 0)
                    ? _removeCounter
                    : null),
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
        body: new FutureBuilder(
            future: _load(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _getOrientationBasedWidget(_getCounterCards());
              }
              return Container();
            }));
  }
}

class Choice {
  const Choice({this.title});

  final String title;
}
