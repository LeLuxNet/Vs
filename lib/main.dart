import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vs/screens/game_screen.dart';
import 'package:vs/screens/game_settings_screen.dart';
import 'package:vs/screens/settings_screen.dart';
import 'package:vs/services/localization.dart';
import 'package:vs/services/service_locator.dart';

void main() {
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Vs.',
        theme: ThemeData(primarySwatch: Colors.yellow),
        darkTheme:
            ThemeData(brightness: Brightness.dark, accentColor: Colors.grey),
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
        onGenerateRoute: (RouteSettings settings) {
          print('Build route for ${settings.name}');
          var routes = <String, WidgetBuilder>{
            '/': (context) => GameScreen(null),
            GameScreen.navigationName: (context) =>
                GameScreen(settings.arguments),
            GameSettingsScreen.navigationName: (context) =>
                GameSettingsScreen(settings.arguments),
            SettingsScreen.navigationName: (context) => SettingsScreen(),
          };
          WidgetBuilder builder = routes[settings.name];
          return MaterialPageRoute(builder: (context) => builder(context));
        });
  }
}
