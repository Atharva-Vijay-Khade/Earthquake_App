import 'dart:async';

import 'package:earthquake_app/Model/model.dart';
import 'package:earthquake_app/Network/network.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MaterialApp(
    home: Earthquake(),
  ));
}

class Earthquake extends StatefulWidget {
  @override
  _EarthquakeState createState() => _EarthquakeState();
}

class _EarthquakeState extends State<Earthquake> {
  Future<Quakes> _earthQuakes;

  // this completer gets value in future forom the googlemapcontorller
  // given by the onmapcreated property
  Completer<GoogleMapController> _completer = Completer();

  List<Marker> _markers = [];

  double _zoomVal = 5.0; // default

  @override
  void initState() {
    super.initState();
    _earthQuakes = Network.getQuakes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          _zoomIn(),
          _zoomOut(),
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton.extended(
                onPressed: () {
                  showEarthQuakes(context);
                },
                label: Text("Show EarthQuakes"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        mapType: MapType.hybrid,
        onMapCreated: (GoogleMapController controller) {
          _completer.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(45.50484936132229, -122.6751553073942),
          zoom: 1,
        ),
        markers: _markers.toSet(),
      ),
    );
  }

  showEarthQuakes(BuildContext context) {
    setState(() {
      _markers.clear();
      setUpMarkers();
    });
  }

  void setUpMarkers() {
    setState(() {
      _earthQuakes.then((quakes) => {
            quakes.features.forEach((element) {
              _markers.add(
                Marker(
                  onTap: () {},
                  markerId: MarkerId(element.id),
                  position: LatLng(element.geometry.coordinates[1],
                      element.geometry.coordinates[0]),
                  infoWindow: InfoWindow(
                      title: "Magnitude: ${element.properties.mag.toString()}",
                      snippet: element.properties.place),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueCyan),
                ),
              );
            })
          });
    });
  }

  Widget _zoomIn() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: Icon(Icons.zoom_in_outlined),
          iconSize: 50,
          color: Colors.white,
          onPressed: () async {
            // now update the camera
            GoogleMapController controller = await _completer.future;
            _zoomVal = await controller.getZoomLevel();
            _zoomVal++;
            LatLng curLoc = await controller.getLatLng(
              ScreenCoordinate(
                x: (MediaQuery.of(context).size.width *
                        MediaQuery.of(context).devicePixelRatio ~/
                        2)
                    .toInt(),
                y: MediaQuery.of(context).size.height *
                    MediaQuery.of(context).devicePixelRatio ~/
                    2,
              ),
            );
            controller
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: curLoc,
              zoom: _zoomVal,
            )));
            print("hello");
          },
        ),
      ),
    );
  }

  Widget _zoomOut() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          icon: Icon(Icons.zoom_out_outlined),
          iconSize: 50,
          color: Colors.white,
          onPressed: () async {
            // now update the camera
            GoogleMapController controller = await _completer.future;
            _zoomVal = await controller.getZoomLevel();
            _zoomVal--;
            LatLng curLoc = await controller.getLatLng(ScreenCoordinate(
                x: MediaQuery.of(context).size.width *
                    MediaQuery.of(context).devicePixelRatio ~/
                    2,
                y: MediaQuery.of(context).size.height *
                    MediaQuery.of(context).devicePixelRatio ~/
                    2));
            controller
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: curLoc,
              zoom: _zoomVal,
            )));
            print("hello");
          },
        ),
      ),
    );
  }
}
