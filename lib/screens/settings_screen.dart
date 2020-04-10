import 'package:flutter/material.dart';
import 'package:vs/models/settings.dart';
import 'package:vs/services/data_service.dart';
import 'package:vs/services/localization.dart';
import 'package:vs/services/service_locator.dart';

class SettingsScreen extends StatefulWidget {
  static final String navigationName = "/settings";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  DataService _dataService = locator<DataService>();
  Future<Settings> _settings;

  @override
  void initState() {
    _settings = _dataService.getSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate("settings")),
        ),
        body: FutureBuilder<Settings>(
            future: _settings,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: <Widget>[
                    SwitchListTile(
                        title: Text(
                            AppLocalizations.of(context).translate("wakeLock")),
                        secondary: Icon(Icons.brightness_medium),
                        value: snapshot.data.wakeLock,
                        onChanged: (value) {
                          snapshot.data.wakeLock = value;
                          _dataService.saveSettings(snapshot.data);
                        })
                  ],
                );
              }
              return Container();
            }));
  }
}
