import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vs/components/list_section.dart';
import 'package:vs/components/promtdialog.dart';
import 'package:vs/models/game.dart';
import 'package:vs/models/gametype/game_type.dart';
import 'package:vs/screens/game_screen.dart';
import 'package:vs/services/localization.dart';

class GameSettingsScreen extends StatefulWidget {
  static final String navigationName = "/game_settings";

  Game game;
  bool newGame;

  GameSettingsScreen(this.game, this.newGame);

  GameSettingsScreen.args(map) : this(map["game"], map["new"]);

  @override
  _GameSettingsScreenState createState() => _GameSettingsScreenState();
}

class _GameSettingsScreenState extends State<GameSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)
                .translate(widget.newGame ? "newGame" : "editGame"))),
        body: ListView(children: <Widget>[
          ListSection(AppLocalizations.of(context).translate("general"), [
            ListTile(
                title: Text(widget.game.getName(AppLocalizations.of(context))),
                leading: Icon(Icons.text_fields),
                onTap: _showNameDialog),
            ListTile(
                title: Text(AppLocalizations.of(context)
                    .translate(widget.game.gameType.getI18nName())),
                leading: Icon(Icons.videogame_asset),
                onTap: widget.newGame ? _showGameTypeDialog : null),
            SwitchListTile(
                title: Text(
                    AppLocalizations.of(context).translate("negativeAllowed")),
                secondary: Icon(Icons.remove_circle),
                value: widget.game.negativeAllowed,
                onChanged: widget.game.setNegativeAllowed)
          ]),
          _getDangerousZone()
        ]),
        floatingActionButton: _getFab());
  }

  Widget _getFab() {
    if (!widget.newGame) {
      return null;
    }
    return FloatingActionButton(
      child: Icon(Icons.play_arrow),
      onPressed: () {
        widget.game.addCounter();
        Navigator.pushNamed(context, GameScreen.navigationName,
            arguments: Future.value(widget.game));
      },
    );
  }

  _showNameDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            PromptDialog(
                AppLocalizations.of(context).translate("changeName"),
                AppLocalizations.of(context).translate("name"), (name) {
              setState(() => widget.game.name = name);
              widget.game.save();
            }, value: widget.game.name));
  }

  _showGameTypeDialog() {
    showDialog<GameType>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text(
                  AppLocalizations.of(context).translate("gameTypeSelection")),
              children: GameType.list
                  .map((e) =>
                  ListTile(
                      leading: Icon(e.icon),
                      title: Text(AppLocalizations.of(context)
                          .translate(e.getI18nName())),
                      onTap: () => Navigator.pop(context, e)))
                  .toList());
        }).then((gameType) {
      if (gameType == null) {
        return;
      }
      setState(() {
        widget.game.gameType = gameType;
      });
      widget.game.save();
    });
  }

  Widget _getDangerousZone() {
    if (widget.newGame) {
      return Container();
    }
    return ListSection(
        AppLocalizations.of(context).translate("dangerousZone"),
        [
          ListTile(
            title: Text(AppLocalizations.of(context).translate("restartGame")),
            leading: Icon(Icons.refresh),
            onTap: () {
              widget.game.restart();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate("deleteGame")),
            leading: Icon(Icons.delete),
            onTap: () {
              setState(() {
                Navigator.pushReplacementNamed(
                    context, GameScreen.navigationName,
                    arguments: widget.game.delete());
              });
            },
          )
        ],
        color: Colors.red);
  }
}
