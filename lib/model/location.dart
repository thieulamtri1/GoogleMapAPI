import 'package:geolocator/geolocator.dart';

class Location{
  String name;
  Position position;

  Location({this.name, this.position});
}

List<Location> locations = [
  Location(name: "Gà Spa", position: Position(latitude: 10.792586195395378, longitude: 106.68616379757441)),
  Location(name: "MTP", position: Position(latitude: 10.842027301414552, longitude: 106.80933062641029)),
  Location(name: "30Shine", position: Position(latitude: 10.788441490138904, longitude: 106.69386201291704)),
];