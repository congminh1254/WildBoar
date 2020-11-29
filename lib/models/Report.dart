import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String currentUserUid;
  String coordinate;
  List<String> images;
  String status;
  String type;
  String handled;
  String description;
  FieldValue time;

  Report({
    this.currentUserUid,
    this.coordinate,
    this.images,
    this.status,
    this.type,
    this.handled,
    this.description,
    this.time,
  });

  Map toMap(Report report) {
    var data = Map<String, dynamic>();
    data['ownerUid'] = report.currentUserUid;
    data['coordinate'] = report.coordinate;
    data['images'] = report.images;
    data['status'] = report.status;
    data['type'] = report.type;
    data['handle'] = report.handled;
    data['description'] = report.description;

    data['time'] = report.time;

    return data;
  }

  Report.fromMap(Map<String, dynamic> mapData) {
    this.currentUserUid = mapData['ownerUid'];
    this.coordinate = mapData['coordinate'];
    this.images = mapData['images'];
    this.status = mapData['status'];
    this.type = mapData['type'];
    this.handled = mapData['handled'];
    this.description = mapData['description'];
    this.time = mapData['time'];
  }
}
