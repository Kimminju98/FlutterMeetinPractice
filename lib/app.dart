import 'package:flutter/material.dart';

import 'chat.dart';
import 'home.dart';

class MeetinApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      ),
      title: 'Meetin Demo',
      home: Home(),
      initialRoute: '/home',
      routes: {
        '/home' : (context) => Home(),
        '/chat': (context) => Chat(),
      },
    );
  }
}