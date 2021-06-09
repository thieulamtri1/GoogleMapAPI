import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_maps/model/location.dart';
import 'package:flutter_maps/secrets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CaculateDistance extends StatefulWidget {
  @override
  _CaculateDistanceState createState() => _CaculateDistanceState();
}


class _CaculateDistanceState extends State<CaculateDistance> {
  Position _currentPosition ;//Position(latitude: 10.79256817537644, longitude: 106.68611383772756);
  Position destinationCoordinates = Position(latitude: 10.795671651313667, longitude: 106.68205620725249);
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  String _placeDistance;
  List<double> distanceAscending = [];



  @override
  void initState() {
    super.initState();
    //getCurrentLocation();
    //getDistance();
    getListAscending();
  }




  getCurrentLocation() async {

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        print('Current lat: ${position.latitude} và Log: ${position.longitude}');
      });
    }).catchError((e) {
      print(e);
    });
  }

  createPolylines(Position start, Position destination) async {
    polylineCoordinates = [];
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY,
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
  }

  caculateDistance() async{
    double totalDistance = 0.0;
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }
    _placeDistance = totalDistance.toStringAsFixed(2);
    print('DISTANCE Nè: $_placeDistance km');

  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }



  getDistance() async{
    await getCurrentLocation();
    await createPolylines(_currentPosition, destinationCoordinates);
    await caculateDistance();

  }

  getListAscending() async{
    await getCurrentLocation();
    for (int i = 0; i < locations.length; i++) {
      await createPolylines(_currentPosition, locations[i].position);
      await caculateDistance();
      print("Distance thứ $i: $_placeDistance");
      double b = double.parse(_placeDistance);
      distanceAscending.add(b);
    }

    double temp;
    for(int i = 0; i < distanceAscending.length - 1; i++){
      for(int j = i+1; j < distanceAscending.length; j++){
        if(distanceAscending[i] > distanceAscending[j]){
          temp = distanceAscending[i];
          distanceAscending[i] = distanceAscending[j];
          distanceAscending[j] = temp;
        }
      }
    }

    print("List Ascending: ${distanceAscending}");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("Lat: "),
          Text("Long: ")
        ],
      )
    );
  }
}
