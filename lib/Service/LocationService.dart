import 'dart:convert';
import 'package:flutter_maps/model/Location.dart';
import 'package:http/http.dart' as http;


class LocationService {
  static const String url = "https://swp490spa.herokuapp.com/api/public/getallspa";

  static Future<LocationReal> getLocation() async {
    try {
      final response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200) {
        return locationRealFromJson(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Failed to load Location');
      }
    } catch (e) {
      throw Exception('Failed to load Location');
    }
  }



}
