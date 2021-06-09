import 'package:geolocator/geolocator.dart';

class Location{
  String name;
  Position position;

  Location({this.name, this.position});
}

List<Location> locations = [
  Location(name: "CongVienLV8", position: Position(latitude: 10.787742498634124, longitude: 106.69222660532054)),
  Location(name: "Fit24", position: Position(latitude: 10.788992586967384, longitude: 106.68322641418833)),
  Location(name: "NgaTuPhuNhuan", position: Position(latitude: 10.799065970554844, longitude: 106.68018513545996)),
];