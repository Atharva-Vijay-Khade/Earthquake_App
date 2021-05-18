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

  GoogleMapController googleMapController;   // this has the controller to the map widget 

  static final LatLng _center = const LatLng(45.521563, -122.677433);  // LatLng object to setup initial camera position

  void _onMapCreated(GoogleMapController controller) { // function to setup the map controller
    googleMapController = controller;
  }

  Marker portlandMarker = Marker(
    markerId: MarkerId("Portland"), // gives marker the id
    position: _center,                        // to be used as position the _center should be static 
    infoWindow: InfoWindow(title: "Portland",snippet: "City in Oregon"), // info abt marker
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),  // pointing location icon
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Earthquake"),
      ),
      body: GoogleMap(          // this widget creates the google map widget 
        mapType: MapType.hybrid,
        markers: {portlandMarker},
        onMapCreated: _onMapCreated,     // this calls the onmapcreate function and passes the controller which is then setup
        initialCameraPosition: CameraPosition(target: _center,zoom: 11.0), // setting the initial camera position
      ),
    );
  }
}



