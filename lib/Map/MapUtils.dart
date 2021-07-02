import 'package:url_launcher/url_launcher.dart';

class MapUtils{
  MapUtils._();

  static Future<void> openMap(double latitudeOrigin, double longitudeOrigin, double latitudeDestination, double longitudeDestination) async{
   // String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&origin=$latitudeOrigin,$longitudeOrigin&destination=$latitudeDestination,$longitudeDestination&travelmode=driving';
    if(await canLaunch(googleUrl)){
      await launch(googleUrl);
    }else{
      throw 'Can not open map';
    }
  }

}