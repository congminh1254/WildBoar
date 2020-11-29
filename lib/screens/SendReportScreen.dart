import 'package:flutter/material.dart';

class SendReportScreen extends StatefulWidget {
  @override
  _SendReportScreenState createState() => _SendReportScreenState();
}

class _SendReportScreenState extends State<SendReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("My Report",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
            )),
        backgroundColor: new Color(0xfff8faf8),
        centerTitle: true,
        elevation: 1.0,
      ),
    );
  }
}
