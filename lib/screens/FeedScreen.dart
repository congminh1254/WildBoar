import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  GoogleMapController _controller;
  Location _location = Location();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<Asset> _images = List<Asset>();

  static final CameraPosition _kCentrum =
      CameraPosition(target: LatLng(52.2289423, 21.0039207), zoom: 10);

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  bool isMapInit = false;
  LocationData currentLocation = null;
  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      if (!isMapInit) {
        isMapInit = true;
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.report),
        label: Text('Report'),
        onPressed: _sendNewReport,
      ),
      body: GoogleMap(
        mapType: MapType.terrain,
        zoomControlsEnabled: false,
        initialCameraPosition: _kCentrum,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        onLongPress: _mapLongPress,
        markers: Set<Marker>.of(markers.values),
      ),
    );
  }

  Future<void> _sendNewReport() async {
    print("New report current location!!!");
    LocationData data = await _location.getLocation();
    _mapLongPress(new LatLng(data.latitude, data.longitude));
    return;
  }

  Future<void> _mapLongPress(LatLng location) async {
    _images = null;
    MarkerId markerId = MarkerId("newMarker");
    final Marker marker = Marker(
      markerId: markerId,
      position: location,
      infoWindow: InfoWindow(title: "Report", snippet: '*'),
    );
    setState(() {
      markers[markerId] = marker;
    });
    await _controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 15),
      ),
    );
    _controller.moveCamera(
      CameraUpdate.scrollBy(0, 225),
    );
    await showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: ListView(
            children: <Widget>[
              AppBar(
                title: Text(
                  "Submit a Report",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                leading: new Container(),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 1.0,
              ),
              Padding(
                padding: EdgeInsets.all(0),
                child: Column(
                  children: [
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  "Photo:",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    (_images != null && _images.length > 0)
                        ? buildGridView()
                        : Container(),
                    IconButton(
                        onPressed: _addReportPhoto,
                        icon: Icon(Icons.add_a_photo)),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  "Coordinate:",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: new TextField(
                                controller: TextEditingController()
                                  ..text = location.latitude.toString() +
                                      ", " +
                                      location.longitude.toString(),
                                decoration: const InputDecoration(
                                  hintText: "Coordinate",
                                ),
                                enabled: false,
                                autofocus: false,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  "Status:",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Radio(value: 0),
                        new Text(
                          'Alive',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        new Radio(value: 1),
                        new Text(
                          'Dead',
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  "Report Type:",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Radio(value: 0),
                        new Text(
                          'Private',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        new Radio(value: 1),
                        new Text(
                          'Public',
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  "Need to be handled:",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Radio(value: 0),
                        new Text(
                          'Yes',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        new Radio(value: 1),
                        new Text(
                          'No',
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  "Description:",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                        ))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );

    setState(() {
      markers.clear();
    });
  }

  Widget buildGridView() {
    if (_images == null)
      print("Images null!");
    else
      print("Image length: " + _images.length.toString());
    try {
      if (_images != null)
        return CarouselSlider(
          options: CarouselOptions(height: 150.0),
          items: List.generate(_images.length, (index) {
            Asset asset = _images[index];
            return AssetThumb(asset: asset, height: 150, width: 300);
          }),
        );
    } catch (ex) {}
    return Container(color: Colors.white);
  }

  Future<void> _addReportPhoto() async {
    print("Open Photos");
    setState(() {
      _images = List<Asset>();
    });
    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      _images = resultList;
      if (error == null) print('No Error Dectected');
    });
  }
}
