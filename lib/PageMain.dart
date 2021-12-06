import 'package:fieta/PageRegister.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fieta/PageLogin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:fieta/singletons/AppData.dart';

class PageMain extends StatefulWidget {
  @override
  _PageMainState createState() => _PageMainState();
}

class _PageMainState extends State<PageMain> {
  String _message;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final bg = Container(
    decoration: BoxDecoration(
        image: DecorationImage(
      image: AssetImage('assets/images/stud.jpeg'),
      fit: BoxFit.cover,
    )),
  );

  final purpleopacity = Container(
    color: Colors.deepPurpleAccent.withOpacity(0.6),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.getToken().then((token) {
      final tokenStr = token.toString();
      // do whatever you want with the token here

      print(token.toString());

      appData.deviceToken = tokenStr;
    });

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');

      setState(() => _message = message["notification"]["title"]);
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');

      setState(() => _message = message["notification"]["title"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');

      setState(() => _message = message["notification"]["title"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          bg,
          purpleopacity,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 70.0, bottom: 5.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
                height: 150.0,
                width: MediaQuery.of(context).size.width,
              ),
              Text(
                'FiETA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'LobsterTwo',
                  letterSpacing: 1,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                '"Your Exam Companion"',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 19.0,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'LobsterTwo',
                  letterSpacing: 1,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: Container(
                  child: null,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 90.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      //height: 50.0,
                      //color: Colors.deepPurpleAccent,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: FlatButton(
                        color: Colors.white.withOpacity(0.35),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new PageRegister()));
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      //height: 50.0,
                      //color: Colors.deepPurpleAccent,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(50)),
                        color: Colors.deepPurpleAccent.withOpacity(0.7),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new PageLogin()));
                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  /*
                  Center(
                    child: FloatingActionButton.extended(
                      elevation: 0,
                      backgroundColor: Colors.white.withOpacity(0.6),
                      icon: Icon(Icons.lock_open),
                      label: Text('Log In'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                new PageLogin()));
                      },
                    ),
                  )*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
