import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vs/models/game.dart';
import 'package:vs/screens/game_screen.dart';
import 'package:vs/services/data_service.dart';
import 'package:vs/services/localization.dart';
import 'package:vs/services/service_locator.dart';

class DrawerWidget extends StatefulWidget {
  DataService _dataService = locator<DataService>();

  DrawerWidget();

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
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: FutureBuilder<List<Game>>(
            future: _games,
            builder: (context, snapshot) {
              List<Widget> entries = [
                DrawerHeader(
                  child: Text(AppLocalizations.of(context).translate("appName")),
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                ),
              ];
              if (snapshot.hasData) {
                snapshot.data.forEach((e) {
                  entries.add(ListTile(
                      leading: Icon(MdiIcons.fromString(
                          "dice" + e.counter.length.toString())),
                      title: Text(e.getName(AppLocalizations.of(context))),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, GameScreen.navigationName,
                            arguments: Future.value(e));
                      }));
                });
              }
              entries.add(ListTile(
                  leading: Icon(Icons.add),
                  title:
                      Text(AppLocalizations.of(context).translate("newGame")),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, GameScreen.navigationName,
                        arguments: widget._dataService.createGame());
                  }));
              return ListView(padding: EdgeInsets.zero, children: entries);
            }));
  }
}
