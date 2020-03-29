import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vs/screens/main_screen.dart';
import 'package:vs/screens/settings_screen.dart';
import 'package:vs/services/localization.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Vs.',
        theme: ThemeData(primarySwatch: Colors.yellow),
        darkTheme: ThemeData(
            brightness: Brightness.dark, primarySwatch: Colors.yellow),
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
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          print('Build route for ${settings.name}');
          var routes = <String, WidgetBuilder>{
            "/": (context) => MainScreen(settings.arguments),
            "/settings": (context) => SettingsScreen(),
          };
          WidgetBuilder builder = routes[settings.name];
          return MaterialPageRoute(builder: (context) => builder(context));
        });
  }
}
