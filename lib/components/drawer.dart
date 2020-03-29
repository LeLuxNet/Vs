import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vs/models/game.dart';
import 'package:vs/services/localization.dart';
import 'package:vs/services/store.dart';

class DrawerWidget extends StatefulWidget {
  DataStore store;

  DrawerWidget(this.store);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Future<List<Game>> _games;

  @override
  void initState() {
    _games = widget.store.getGames();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: FutureBuilder<List<Game>>(
            future: _games,
            builder: (context, snapshot) {
              List<Widget> entries = [
                DrawerHeader(
                  child:
                      Text(AppLocalizations.of(context).translate("appName")),
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                ),
              ];
              if (snapshot.hasData) {
                snapshot.data.forEach((e) {
                  entries.add(ListTile(
                      leading: Icon(MdiIcons.fromString(
                          "dice" + e.counter.length.toString())),
                      title: Text(e.name),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "/",
                            arguments: e.id);
                      }));
                });
              }
              entries.add(ListTile(
                  leading: Icon(Icons.add),
                  title:
                      Text(AppLocalizations.of(context).translate("newGame")),
                  onTap: () {
                    widget.store.createGame(context).then((game) =>
                        Navigator.pushReplacementNamed(context, "/",
                            arguments: game.id));
                  }));
              return ListView(padding: EdgeInsets.zero, children: entries);
            }));
  }
}
