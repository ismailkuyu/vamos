import 'package:flutter/material.dart';
import 'package:vamos/dashboard.dart';
import 'package:vamos/stateContainer.dart';

void main() => runApp(new StateContainer(child: new MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Vamos!',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Dashboard(),
    );
  }
}
