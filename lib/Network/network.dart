
import 'dart:convert';


import 'package:earthquake_app/Model/model.dart';
import 'package:http/http.dart' as https;

class Network {

  static Future<Quakes> getQuakes() async {

    var quakeUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson";

    var response = await https.get(Uri.https("earthquake.usgs.gov","earthquakes/feed/v1.0/summary/2.5_day.geojson"));

    if(response.statusCode == 200)
    {
     // print(response.body);
      return Quakes.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("error occurred");
    }
  }
}