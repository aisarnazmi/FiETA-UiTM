import 'package:flutter/material.dart';

import 'package:undraw/undraw.dart';

import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:fieta/utils/UrlString.dart';
import 'package:fieta/singletons/AppData.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class _PageLoginState extends State<PageLogin> {
  bool _obscureText = true;
  bool _isLogin = false;

  SharedPreferences sharedPreferences;

  TextEditingController untxt = new TextEditingController();
  TextEditingController uptxt = new TextEditingController();

  Future _loginApps(BuildContext context) async {
    var url = UrlStr.getUrl() + "loginfieta.php";

    http.post(url, body: {
      "usrid": untxt.text,
      "usrpass": uptxt.text,
      "deviceid": appData.deviceToken,
    }).then((response) {
      print(response.body);

      var data = jsonDecode(response.body);

      if (data['msg'] == "1") {
        setState(() {
          _isLogin = false;

          appData.studID = data['STUDID'];
          appData.studName = data['STUDNAME'];
          appData.studCamp = data['STUDCAMP'];
          appData.studProg = data['STUDPROG'];
          appData.studSubj = data['STUDSUBJ'];
          appData.studPass = data['STUDPASS'];
        });

        Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, '/PageHomeStudent');

      } else if (data['msg'] == "0") {
        setState(() {
          _isLogin = false;
        });

        _scaffoldKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.red,
            content: new Text(
              "Student ID or Password not match, please try again!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white70,
                fontSize: 16.0,
              ),
            )));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCredential();
  }

  _onLogin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString("userid", untxt.text);
      sharedPreferences.setString("password", uptxt.text);
      sharedPreferences.commit();
      getCredential();
    });
  }

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      String check = sharedPreferences.getString("userid");
      if (check != null) {
        untxt.text = sharedPreferences.getString("userid");
        uptxt.text = sharedPreferences.getString("password");
      } else {
        untxt.clear();
        uptxt.clear();
        sharedPreferences.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Log In'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            child: Column(
              children: <Widget>[
                Container(
                  child: UnDraw(
                    color: Colors.deepPurpleAccent,
                    illustration: UnDrawIllustration.authentication,
                    placeholder: Text(
                        "Checking Internet Connection..."), //optional, default is the CircularProgressIndicator().
                    errorWidget: FlatButton.icon(
                      //color: Colors.white,
                      onPressed: (){},
                      icon: Icon(Icons.perm_scan_wifi), //`Icon` to display
                      label: Text('No Internet Connection'), //`Text` to display
                    ), /* Icon(Icons.perm_scan_wifi,
                        color: Colors.red,
                        size:
                            50), */ //optional, default is the Text('Could not load illustration!').
                  ),
                  height: 150.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: untxt,
                  decoration: InputDecoration(
                    labelText: 'Student ID',
                    suffixIcon: Icon(
                      Icons.account_circle,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  controller: uptxt,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: new GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                  obscureText: _obscureText,
                ),
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 60.0,
                  child: RaisedButton.icon(
                    textColor: Colors.white,
                    icon: Icon(Icons.lock_open),
                    onPressed: () {
                      _onLogin();
                      _loginApps(context);

                      setState(() {
                        _isLogin = true;
                      });
                    },
                    label: _isLogin
                        ? new CircularProgressIndicator(
                            backgroundColor: Colors.white70,
                          )
                        : Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
