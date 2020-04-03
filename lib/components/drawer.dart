import 'dart:ffi';
import 'dart:wasm';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vs/models/game.dart';
import 'package:vs/screens/game_screen.dart';
import 'package:vs/services/data_service.dart';
import 'package:vs/services/localization.dart';
import 'package:vs/services/service_locator.dart';

class DrawerWidget extends StatefulWidget {
  final DataService _dataService = locator<DataService>();

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Future<List<Game>> _games;

  @override
  void initState() {
    _games = widget._dataService.getGames();
    _games.then((value) => print(
        "Available Games: " + value.map((v) => v.id).toList().toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: _getItemList());
  }

  Widget _getDrawerHead() {
    return DrawerHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_getAppName()),
        ],
      ),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
    );
  }

  Widget _getItemList() {
    return Expanded(
      child: FutureBuilder<List<Game>>(
          future: _games,
          builder: (context, snapshot) {
            List<Widget> entries = [_getDrawerHead()];
            if (snapshot.hasData) {
              snapshot.data.forEach((e) => entries.add(_getGameButton(e)));
            }
            entries.add(_getNewGameButton());
            return ListView(padding: EdgeInsets.zero, children: entries);
          }),
    );
  }

  Widget _getGameButton(Game game) {
    return ListTile(
        leading:
            Icon(MdiIcons.fromString("dice" + game.counter.length.toString())),
        title: Text(game.getName(AppLocalizations.of(context))),
        onTap: () {
          Navigator.pushReplacementNamed(context, GameScreen.navigationName,
              arguments: Future.value(game));
        });
  }

  Widget _getNewGameButton() {
    return ListTile(
        leading: Icon(Icons.add),
        title: Text(AppLocalizations.of(context).translate("newGame")),
        onTap: () {
          Navigator.pushReplacementNamed(context, GameScreen.navigationName,
              arguments: widget._dataService.createGame());
        });
  }

  String _getAppName() {
    if (kReleaseMode) {
      return AppLocalizations.of(context).translate("appName");
    }
    return AppLocalizations.of(context).translate("appName") + " (Debug)";
  }
}
