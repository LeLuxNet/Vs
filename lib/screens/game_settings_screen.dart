import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vs/components/list_section.dart';
import 'package:vs/models/game.dart';
import 'package:vs/screens/game_screen.dart';
import 'package:vs/services/localization.dart';

class GameSettingsScreen extends StatefulWidget {
  static final String navigationName = "/game_settings";

  Game game;

  GameSettingsScreen(this.game);

  @override
  _GameSettingsScreenState createState() => _GameSettingsScreenState();
}

class _GameSettingsScreenState extends State<GameSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context).translate("editGame"))),
        body: ListView(children: <Widget>[
          ListSection(
              AppLocalizations.of(context).translate("dangerousZone"),
              [
                ListTile(
                  title: Text(
                      AppLocalizations.of(context).translate("deleteGame")),
                  subtitle: Text('Subtitle comming soon...'),
                  leading: Icon(Icons.delete),
                  onTap: () {
                    setState(() {
                      Navigator.pushReplacementNamed(
                          context, GameScreen.navigationName,
                          arguments: widget.game.delete());
                    });
                  },
                )
              ],)
        ]));
  }
}
