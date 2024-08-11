import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerService {
  Map<MarkerId, Marker> createMarkers(double originLatitude, double originLongitude, double destLatitude, double destLongitude) {
    MarkerId originMarkerId = MarkerId('origin_marker');
    MarkerId destinationMarkerId = MarkerId('destination_marker');

    Marker originMarker = Marker(
      markerId: originMarkerId,
      position: LatLng(originLatitude, originLongitude),
      infoWindow: InfoWindow(title: 'Başlangıç Noktası'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: destinationMarkerId,
      position: LatLng(destLatitude, destLongitude),
      infoWindow: InfoWindow(title: 'Bitiş Noktası'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    return {
      originMarkerId: originMarker,
      destinationMarkerId: destinationMarker,
    };
  }
}
