import 'package:flutter/material.dart';

import 'home.dart';
import 'notification.dart';

class MeetinApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      ),
      title: 'Organic Life Demo',
      home: Home(),
      initialRoute: '/home',
      routes: {
        '/home' : (context) => Home(),
        '/notification' : (context) => NotificationTest(),
      },
    );
  }
}