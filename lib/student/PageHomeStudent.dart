import 'package:flutter/material.dart';

import 'package:fieta/student/PageCounterExam.dart';
import 'package:fieta/student/PageCalendar.dart';
import 'package:fieta/student/PageListTT.dart';


class PageHomeStudent extends StatefulWidget {
  @override
  _PageHomeStudentState createState() => _PageHomeStudentState();
}

class _PageHomeStudentState extends State<PageHomeStudent> {
  int _counter;

  int _selectedIndex = 0;
  final _layoutPage = [
    PageCounterExam(),
    PageCalendar(),
    PageListTT(),
    //PageNotifications(),
    //PageCart()
  ];

  void _onTabItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FiETA'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.withOpacity(0.9),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.lock),
              onPressed: () {
                //Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/PageLogin');
              }),
        ],
      ),
      body: _layoutPage.elementAt(_selectedIndex),
      bottomNavigationBar: new BottomNavigationBar(
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.8),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.timer,
            ),
            title: Text('COUNTER'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text("CALENDAR"),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_list), title: Text("DETAILS")),
          /* BottomNavigationBarItem(
              icon:Icon(Icons.notifications_active),
              title: Text("NOTIFICATIONS")
          ), */
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onTabItem,
      ),
    );
  }
}
