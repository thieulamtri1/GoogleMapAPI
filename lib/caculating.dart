import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_maps/model/locationTest.dart';
import 'package:flutter_maps/secrets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Map/MapUtils.dart';
import 'Service/LocationService.dart';
import 'model/Location.dart';

class CaculateDistance extends StatefulWidget {
  @override
  _CaculateDistanceState createState() => _CaculateDistanceState();
}

class _CaculateDistanceState extends State<CaculateDistance> {
  Position
      _currentPosition; //Position(latitude: 10.79256817537644, longitude: 106.68611383772756);
  Position destinationCoordinates =
      Position(latitude: 10.795671651313667, longitude: 106.68205620725249);
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  String _placeDistance;
  List<Location> distanceAscending = [];
  LocationReal locationReal;
  double latitude;
  double longitude;

  @override
  void initState() {
    super.initState();
    //getCurrentLocation();
    //getDistance();
    //getListAscending();
    getData();
  }

  getData() async {
    await LocationService.getLocation().then((value) => {
          setState(() {
            locationReal = value;
          }),
        });
    print("Location: ${locationReal.data[0].name}");
    print("Location: ${locationReal.data[0].latitude}");
    print("Location: ${locationReal.data[0].longtitude}");
  }

  getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        latitude = position.latitude;
        longitude = position.longitude;
        print('CURRENT POS: $_currentPosition');
        print(
            'Current lat: ${position.latitude} và Log: ${position.longitude}');
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

  caculateDistance() async {
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

  getDistance() async {
    await getCurrentLocation();
    await createPolylines(_currentPosition, destinationCoordinates);
    await caculateDistance();
  }

  getListAscending() async {
    await getCurrentLocation();
    for (int i = 0; i < locations.length; i++) {
      await createPolylines(_currentPosition, locations[i].position);
      await caculateDistance();

      print("Distance thứ $i: $_placeDistance");

      double b = double.parse(_placeDistance);

      locations[i].distance = b;
      distanceAscending.add(locations[i]);
    }

    Location temp;
    for (int i = 0; i < distanceAscending.length - 1; i++) {
      for (int j = i + 1; j < distanceAscending.length; j++) {
        if (distanceAscending[i].distance > distanceAscending[j].distance) {
          temp = distanceAscending[i];
          distanceAscending[i] = distanceAscending[j];
          distanceAscending[j] = temp;
        }
      }
    }

    print(
        "List Ascending:  ${distanceAscending[0].name} - ${distanceAscending[0].distance} ");
    print(
        "List Ascending:  ${distanceAscending[1].name} - ${distanceAscending[1].distance} ");
    print(
        "List Ascending:  ${distanceAscending[2].name} - ${distanceAscending[2].distance} ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Địa chỉ của bạn: 15 Nguyễn Trường Tộ"),
          Text("Lat: $latitude"),
          Text("Long: $longitude"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MapUtils.openMap(10.79256817537644,106.68611383772756,10.795671651313667,106.68205620725249);
        },
        child: Text("Map"),
        backgroundColor: Colors.blue,
      ),

    );
  }
}
