import 'package:flutter/material.dart';

import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:fieta/singletons/AppData.dart';
import 'package:fieta/utils/UrlString.dart';

class PageCalendar extends StatefulWidget {
  @override
  _PageCalendarState createState() => _PageCalendarState();
}

class _PageCalendarState extends State<PageCalendar> {

  void _handleNewDate(date) async {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
    });

    print(_selectedDay);
    print(_selectedEvents);
  }

  List _selectedEvents;
  DateTime _selectedDay;

  DateTime date;

  var _events = {};

  Future<List> _loadAllEvents() async {
    var url = UrlStr.getUrl() + "geteventfieta.php";

    try {
      final response = await http.post(url, body: {
        'studprog': appData.studProg,
        'studsubj': appData.studSubj,
      });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (_events.isNotEmpty) {
          _events.clear();
        }

        var c = 0;

        for (var i = 0; i < jsonData.length; i++) {
          var _dt = jsonData[i]['EVT_DETS'];
          //var _ts = jsonData[i]['EVT_TIS'];
          //var _te = jsonData[i]['EVT_TIE'];

          print(_dt);

          List _listDate =
              _dt.split(","); //+ "\t" + _ts.split(",") +" - "+ _te.split(",");

          //print(_dt[0]);
          //print(jsonData[i]['EVT_DT']);

          if (c == 0) {
            _events[DateTime.parse(jsonData[i]['EVT_DT'])] = _listDate
                .map((
                  item,
                ) =>
                    {'name': item, 'isDone': true})
                .toList();

            c = 1;
          } else if (c == 1) {
            _events[DateTime.parse(jsonData[i]['EVT_DT'])] = _listDate
                .map((item) => {'name': item, 'isDone': false})
                .toList();

            c = 0;
          }
        }
        //debugPrint(_events.toString());
        DateTime dateTime = DateTime.now();
        _handleNewDate(DateTime(dateTime.year, dateTime.month, dateTime.day));
      }
    } catch (e) {
      print("Error : " + e.toString());
    }
  }

/*
  final Map _events = {
    DateTime(2019, 3, 1): [
      {'name': 'Event A', 'isDone': true},
    ],
    DateTime(2019, 3, 4): [
      {'name': 'Event A', 'isDone': true},
      {'name': 'Event B', 'isDone': true},
    ],
    DateTime(2019, 3, 5): [
      {'name': 'Event A', 'isDone': true},
      {'name': 'Event B', 'isDone': true},
    ],
    DateTime(2019, 3, 13): [
      {'name': 'Event A', 'isDone': true},
      {'name': 'Event B', 'isDone': true},
      {'name': 'Event C', 'isDone': false},
    ],
    DateTime(2019, 12, 3): [
      {'name': 'Event A', 'isDone': true},
      {'name': 'Event B', 'isDone': true},
      {'name': 'Event C', 'isDone': false},
    ],
    DateTime(2019, 12, 26): [
      {'name': 'Event A', 'isDone': false},
    ],
  };
*/

/*
  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
    });
    print(_selectedEvents);
  }

  List _selectedEvents;
  DateTime _selectedDay;
  */
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedEvents = _events[_selectedDay] ?? [];

    _loadAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Calendar(
                  events: _events,
                  onRangeSelected: (range) =>
                      print("Range is ${range.from}, ${range.to}"),
                  onDateSelected: (date) => _handleNewDate(date),
                  isExpandable: true,
                  showTodayIcon: true,
                  selectedColor: Colors.lightBlueAccent.shade100,
                  eventDoneColor: Colors.redAccent,
                  eventColor: Colors.purple),
            ),
            _buildEventList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.5, color: Colors.black12),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
          child: ListTile(
            title: Text(
              _selectedEvents[index]['name'].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            //trailing: Text(_selectedEvents[index]['time'].toString()),
            onTap: () {
              setState(() {
              });
            },
          ),
        ),
        itemCount: _selectedEvents.length,
      ),
    );
  }
}
