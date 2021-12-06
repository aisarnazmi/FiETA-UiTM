import 'package:flutter/material.dart';
import 'package:fieta/PageMain.dart';

import 'package:fieta/student/PageHomeStudent.dart';
import 'package:fieta/PageLogin.dart';
import 'package:fieta/PageRegister.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new PageMain(),
      routes: <String, WidgetBuilder>{
        "/PageMain": (BuildContext context) => new PageMain(),
        "/PageRegister": (BuildContext context) => new PageRegister(),
        "/PageLogin": (BuildContext context) => new PageLogin(),
        "/PageHomeStudent": (BuildContext context) => new PageHomeStudent(),
      },
    );
  }
}
