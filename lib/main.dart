import 'package:flutter/material.dart';
import 'package:quake_report/Screens/home.dart';
import 'package:quake_report/Screens/loading.dart';
import 'package:quake_report/Screens/settings.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
        '/settings': (context) => Settings(),
      },
    ));
