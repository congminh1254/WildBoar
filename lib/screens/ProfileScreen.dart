import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wild_boar/main.dart';
import 'package:wild_boar/models/user.dart';
import 'package:wild_boar/resources/repository.dart';
import 'package:wild_boar/services/auth_service.dart';

class ProFileScreen extends StatefulWidget {
  @override
  _ProFileScreenState createState() => _ProFileScreenState();
}

class _ProFileScreenState extends State<ProFileScreen> {
  var _repository = Repository();
  Color _gridColor = Colors.blue;
  Color _listColor = Colors.grey;
  bool _isGridActive = true;
  Users _user;
  IconData icon;
  Color color;
  Future<List<DocumentSnapshot>> _future;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: new Color(0xfff8faf8),
        elevation: 1,
        title: new Text("Profile",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
            )),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings_power),
            color: Colors.black,
            onPressed: () {
              AuthService.logout(context);
              _repository.signOut().then((v) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return MyApp();
                }));
              });
            },
          )
        ],
      ),
    );
  }
}
