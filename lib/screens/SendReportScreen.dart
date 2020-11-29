import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wild_boar/models/user.dart';
import 'package:wild_boar/resources/repository.dart';

class SendReportScreen extends StatefulWidget {
  @override
  _SendReportScreenState createState() => _SendReportScreenState();
}

class _SendReportScreenState extends State<SendReportScreen> {
  var _repository = Repository();
  Users currentUser, user;
  static List<String> listID = List<String>();
  Future<List<DocumentSnapshot>> _future;

  @override
  void initState() {
    getReport();
    super.initState();
  }

  void getReport() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    Users user = await _repository.fetchUserDetailsById(currentUser.uid);
    setState(() {
      this.currentUser = user;
    });

    listID = (await _repository.retrieveUserReport(currentUser.uid));
    print(listID.length);
    _future = _repository.fetchReport(currentUser);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("My Report (" + listID.length.toString() + ")",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
            )),
        backgroundColor: new Color(0xfff8faf8),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: (currentUser != null && listID.length > 0)
          ? Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: userReport(),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  // ignore: missing_return
  Widget userReport() {
    return FutureBuilder(
      future: _future,
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                //shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: ((context, index) => listItem(
                      list: snapshot.data,
                      index: index,
                      currentUser: currentUser,
                    )));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  Widget listItem({List<DocumentSnapshot> list, int index, Users currentUser}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      "Report " + (index + 1).toString(), //_user.displayName,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            )),
        Padding(
            padding: EdgeInsets.only(left: 35.0, right: 25.0, top: 25.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      "Coordinate: " +
                          list[index].data['coordinate'], //_user.displayName,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ],
            )),
        Padding(
            padding: EdgeInsets.only(left: 35.0, right: 25.0, top: 25.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      "Status: " +
                          list[index]
                              .data['status']
                              .toString(), //_user.displayName,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ],
            )),
        Padding(
            padding: EdgeInsets.only(left: 35.0, right: 25.0, top: 25.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      "Report type: " +
                          list[index]
                              .data['type']
                              .toString(), //_user.displayName,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ],
            )),
        Padding(
            padding: EdgeInsets.only(left: 35.0, right: 25.0, top: 25.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      "Need to be handled: " +
                          list[index]
                              .data['handle']
                              .toString(), //_user.displayName,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ],
            )),
        Padding(
            padding: EdgeInsets.only(left: 35.0, right: 25.0, top: 25.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      "Description: " +
                          list[index]
                              .data['description']
                              .toString(), //_user.displayName,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ],
            )),
      ],
    );
  }
}
