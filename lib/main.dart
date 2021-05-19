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


    @override
    void initState() { 
      super.initState();
      _earthQuakes = Network.getQuakes();
      _earthQuakes.then((values)=>{
        print("Place: ${values.features[1].geometry.coordinates[0]}" )
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
        ],
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        // child: GoogleMap(
        //   initialCameraPosition: initialCameraPosition),
      );
  }
}

// GoogleMapController
//       googleMapController; // this has the controller to the map widget

//   static final LatLng _center = const LatLng(
//       45.521563, -122.677433); // LatLng object to setup initial camera position
//   static final LatLng _anotherLoc = const LatLng(
//       45.505025, -122.670187); // another location picked up from google maps

// void _onMapCreated(GoogleMapController controller) {
//     // function to setup the map controller
//     googleMapController = controller;
//   }

//   Marker portlandMarker = Marker(
//     markerId: MarkerId("Portland"), // gives marker the id
//     position: _center, // to be used as position the _center should be static
//     infoWindow: InfoWindow(
//         title: "Portland", snippet: "City in Oregon"), // info abt marker
//     icon: BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueAzure), // pointing location icon
//   );

//   Marker portlandMarker2 = Marker(
//     markerId: MarkerId("Portland2"),
//     infoWindow:
//         InfoWindow(title: "Portland Area", snippet: "Another area in portland"),
//     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
//     position: _anotherLoc,
//   );

//   CameraPosition intelLoc = CameraPosition(
//     target: LatLng(18.9644331,73.0193293),
//     tilt: 90,
//     bearing: 191,
//     zoom: 16,
//   );

//   void _gotoIntel()  {
//     GoogleMapController controller = googleMapController;
//     controller.animateCamera(CameraUpdate.newCameraPosition(intelLoc));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Earthquake"),
//       ),
//       body: GoogleMap(
//         // this widget creates the google map widget
//         mapType: MapType.hybrid,
//         markers: {portlandMarker, portlandMarker2},
//         onMapCreated:
//             _onMapCreated, // this calls the onmapcreate function and passes the controller which is then setup
//         initialCameraPosition: CameraPosition(
//             target: _center, zoom: 11.0), // setting the initial camera position
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         icon: Icon(Icons.business_center),
//         onPressed: _gotoIntel,
//         label: Text("Intel Corp!"),
//       ),