import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:fieta/singletons/AppData.dart';
import 'package:fieta/utils/UrlString.dart';

class PageCounterExam extends StatefulWidget {
  @override
  _PageCounterExamState createState() => _PageCounterExamState();
}

class _PageCounterExamState extends State<PageCounterExam> {
  Timer _timer;
  DateTime _currentTime;
  DateTime dexam = DateTime.parse('0000-00-00');
  String exam = 'EXAM';

  Future _loadDate() async {
    var url = UrlStr.getUrl() + "getcounterfieta.php";

    try {
      final response = await http.post(url, body: {
        'studid': appData.studID,
      });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.length > 0) {
          dexam = DateTime.parse(jsonData[0]['DATE']);
          exam = jsonData[0]['SUBJ'];
        }
      }
    } catch (e) {
      print("Error : " + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    _loadDate();

    _currentTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), _onTimeChange);
  }

  void _onTimeChange(Timer timer) {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    Duration remaining = dexam.difference(_currentTime);

    final days = remaining.inDays.floor().toString();
    /* final hours = remaining.inHours - remaining.inDays * 24;
    final minutes = remaining.inMinutes - remaining.inHours * 60;
    final seconds = remaining.inSeconds - remaining.inMinutes * 60; */

    //final formattedRemaining = days+" Days "+hours.toString()+" Hours "+minutes.toString()+" Minutes " +seconds.toString()+" Second";
    String formattedDaysRemaining = days;
    String examSub;

    if (exam.length > 7) {
      examSub = exam + '\nSTART IN ...';
    } else
      examSub = exam + ' START IN ...';

    if (int.parse(formattedDaysRemaining) < 0) {
      formattedDaysRemaining = "--";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(14.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              examSub,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            SizedBox(
              height: 25.0,
            ),
            Text(
              formattedDaysRemaining,
              style: TextStyle(
                fontSize: 130.0,
                color: Colors.deepPurpleAccent,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Divider(indent: 30.0, endIndent: 10.0, thickness: 2),
                ),
                Icon(
                  Icons.local_library,
                  color: Colors.deepPurpleAccent,
                  size: 35.0,
                ),
                Expanded(
                  child: Divider(
                    indent: 10.0,
                    endIndent: 30.0,
                    thickness: 2,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              'Days',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
