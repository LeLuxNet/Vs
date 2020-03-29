import 'package:flutter/material.dart';
import 'package:vs/services/localization.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("settings")),
        ),
        body: Center(child: Text("Settings comming soon...")));
  }
}
