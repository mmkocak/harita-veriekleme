import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineService {
  PolylinePoints polylinePoints = PolylinePoints();

  Future<List<LatLng>> getPolylineCoordinates(
      double originLatitude, double originLongitude, double destLatitude, double destLongitude) async {
    List<LatLng> polylineCoordinates = [];

    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(originLatitude, originLongitude),
          destination: PointLatLng(destLatitude, destLongitude),
          mode: TravelMode.driving,
        ),
        googleApiKey: "YOUR_API_KEY", 
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        throw Exception('No points found in the polyline');
      }
    } catch (e) {
      print("Error occurred: $e");
    }

    return polylineCoordinates;
  }
}
