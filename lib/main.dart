import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vs/screens/main_screen.dart';
import 'package:vs/services/localization.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vs.',
      theme: ThemeData(primarySwatch: Colors.yellow),
      darkTheme: ThemeData.dark(),
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
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) => MainScreen()
      },
    );
  }
}
