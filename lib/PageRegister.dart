import 'package:flutter/material.dart';

import 'package:undraw/undraw.dart';

import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:fieta/utils/UrlString.dart';

class PageRegister extends StatefulWidget {
  @override
  _PageRegisterState createState() => _PageRegisterState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class _PageRegisterState extends State<PageRegister> {

  bool _obscureText = true;
  bool _isRegister = false;

  TextEditingController id = new TextEditingController();
  TextEditingController pwd = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController camp = new TextEditingController();
  TextEditingController prog = new TextEditingController();
  TextEditingController subj = new TextEditingController();

  Future _registerApps(BuildContext context) async{

    var url = UrlStr.getUrl()+"registerfieta.php";

    http.post(url,body: {
      "usrid":id.text,
      "usrpass":pwd.text,
      "usrname":name.text.toUpperCase(),
      "usrcamp":camp.text.toUpperCase(),
      "usrprog":prog.text.toUpperCase(),
      "usrsubj":subj.text.toUpperCase(),
    }).then((response){
      print(response.body);

      var data = jsonDecode(response.body);

      if(data['msg'] == "1"){
        setState(() {
          _isRegister = false;
        });

          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, '/PageLogin');

      }else if (data['msg'] == "0") {
        setState(() {
          _isRegister = false;
        });

        _scaffoldKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.red,
            content: new Text(
              "Register failed, please try again!",
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: Form(
            child: Column(
              children: <Widget>[
                Container(
                  child: UnDraw(
                    color: Colors.deepPurpleAccent,
                    illustration: UnDrawIllustration.add_user,
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
                  controller: id,
                  decoration: InputDecoration(
                    labelText: 'Student ID',
                  ),
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  controller: pwd,
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
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  controller: camp,
                  decoration: InputDecoration(
                    hintText: 'eg. SA',
                    labelText: 'Campus Code',
                  ),
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  controller: prog,
                  decoration: InputDecoration(
                    hintText: 'eg. AD110',
                    labelText: 'Programme Code',
                  ),
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  controller: subj,
                  maxLines: 3,
                  decoration: InputDecoration(                    
                    hintText: 'eg. ACC110,CSC128,LAW110,..',
                    labelText: 'Subject Code',
                    
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 60.0,
                  child: RaisedButton(
                    onPressed: () {
                      _registerApps(context);

                      setState(() {
                        _isRegister = true;
                      });
                    },
                    child: _isRegister
                        ? new CircularProgressIndicator(
                      backgroundColor: Colors.white70,
                    )
                        : Text(
                      'Register',
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
