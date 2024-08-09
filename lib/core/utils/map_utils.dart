import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

class MapUtils {
  static Future<LatLng?> selectPoint(
      BuildContext context, String title, CameraPosition initialCameraPosition) async {
    LatLng? selectedPoint;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: GoogleMap(
            initialCameraPosition: initialCameraPosition,
            onTap: (point) {
              selectedPoint = point;
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
    return selectedPoint;
  }

  static Future<String?> getPolylineName(BuildContext context) async {
    String? polylineName;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Çizgi İsmi Girin'),
        content: TextField(
          onChanged: (value) {
            polylineName = value;
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Tamam'),
          ),
        ],
      ),
    );
    return polylineName;
  }

  static Future<Color?> getPolylineColor(BuildContext context) async {
    Color? selectedColor;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Çizgi Rengi Seçin'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _colorOption(context, Colors.red, 'Kırmızı'),
              _colorOption(context, Colors.green, 'Yeşil'),
              _colorOption(context, Colors.blue, 'Mavi'),
              _colorOption(context, Colors.yellow, 'Sarı'),
              _colorOption(context, Colors.orange, 'Turuncu'),
              _colorOption(context, Colors.purple, 'Mor'),
              _colorOption(context, Colors.pink, 'Pembe'),
              _colorOption(context, Colors.brown, 'Kahverengi'),
              _colorOption(context, Colors.grey, 'Gri'),
            ],
          ),
        ),
      ),
    );
    return selectedColor;
  }

  static void getPolyline(
      String polylineName,
      Color polylineColor,
      PolylinePoints polylinePoints,
      double originLatitude,
      double originLongitude,
      double destLatitude,
      double destLongitude,
      GoogleMapController controller,
      Function(List<LatLng>, String, Color) addPolyline,
      Function(LatLngBounds) addMarkers) async {
    List<LatLng> polylineCoordinates = [];

    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(originLatitude, originLongitude),
          destination: PointLatLng(destLatitude, destLongitude),
          mode: TravelMode.driving,
        ),
        googleApiKey: "AIzaSyD3F26wQhYJ7jMTRuw3rjPTGJlhTUvIhko",
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });

        addPolyline(polylineCoordinates, polylineName, polylineColor);

        LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(
            polylineCoordinates.map((e) => e.latitude).reduce((a, b) => a < b ? a : b),
            polylineCoordinates.map((e) => e.longitude).reduce((a, b) => a < b ? a : b),
          ),
          northeast: LatLng(
            polylineCoordinates.map((e) => e.latitude).reduce((a, b) => a > b ? a : b),
            polylineCoordinates.map((e) => e.longitude).reduce((a, b) => a > b ? a : b),
          ),
        );

        controller.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 50),
        );

        addMarkers(bounds);

        // Mesafeyi Firebase'e kaydet
        double distance = Geolocator.distanceBetween(
          originLatitude,
          originLongitude,
          destLatitude,
          destLongitude,
        ) / 1000; // Mesafeyi kilometre cinsinden hesapla

        _savePolylineToFirebase(polylineName, polylineColor.value, distance);
      } else {
        throw Exception('No points found in the polyline');
      }
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  static Future<void> _savePolylineToFirebase(String polylineName, int colorValue, double distance) async {
    final databaseReference = FirebaseDatabase.instance.ref().child('polylines');

    await databaseReference.push().set({
      'name': polylineName,
      'color': colorValue,
      'distance': distance,
    }).then((_) {
      print("Polyline verileri Firebase'e kaydedildi.");
    }).catchError((error) {
      print("Firebase'e veri kaydetme hatası: $error");
    });
  }

  static ListTile _colorOption(BuildContext context, Color color, String title) {
    return ListTile(
      leading: Icon(Icons.circle, color: color),
      title: Text(title),
      onTap: () {
        Navigator.pop(context, color);
      },
    );
  }
}
