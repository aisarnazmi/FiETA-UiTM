import 'package:flutter/material.dart';

import 'package:fieta/utils/UrlString.dart';
import 'package:fieta/singletons/AppData.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:fieta/shared/loading.dart';

class PageListTT extends StatefulWidget {
  @override
  _PageListTTState createState() => _PageListTTState();
}

class _PageListTTState extends State<PageListTT> {
  Future _getAllSUbjectByStudProg() async {
    var url = UrlStr.getUrl() + "getallsubjfieta.php";

    try {
      final response = await http.post(url, body: {
        'studcamp': appData.studCamp,
        'studprog': appData.studProg,
        'studsubj': appData.studSubj,
      });

      if (response.statusCode == 200) {
        print(response.body);

        return json.decode(response.body);
      }
    } catch (e) {
      print("Error : " + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    //_getAllSUbjectByStudProg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _getAllSUbjectByStudProg(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text(
                    "Sorry, Sorry, No Timetable Data",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            } else {
              if (snapshot.data.toString().length == 4) {
                //print('PORTION HERE');
                return Container(
                  child: Center(
                    child: Text(
                      "Sorry, No Timetable Data!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              } else if (snapshot.data.toString().length > 4 &&
                  snapshot.data != null) {
                //print('PORTION HERE LISTTILE');
                return new ItemList(list: snapshot.data);
                //return Container();
              }
            }
          }
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  List list;

  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      padding: EdgeInsets.all(6.0),
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return Card(
          elevation: 4.0,
          child: Container(
            //padding: EdgeInsets.all(4.0),
            height: 80.0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  //color: Colors.red,
                  height: 80.0,
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                width: 4.0, color: Colors.redAccent.shade200),
                          ),
                        ),
                        height: 80.0,
                        width: 14.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              list[i]['SUBJCODE'] +
                                  "\t\t-\t\t" +
                                  list[i]['DATE'],
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 17.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: Colors.black26,
                                ),
                                SizedBox(
                                  width: 3.0,
                                ),
                                Text(list[i]['VENUE']),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Icon(
                                  Icons.timer,
                                  color: Colors.black26,
                                ),
                                SizedBox(
                                  width: 3.0,
                                ),
                                Text(list[i]['TSTART'] +
                                    " - " +
                                    list[i]['TEND']),
                              ],
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
