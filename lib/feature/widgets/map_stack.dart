import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
class MapStack extends StatelessWidget {
  final CameraPosition initialCameraPosition;
  final Map<PolylineId, Polyline> polylines;
  final Map<MarkerId, Marker> markers;
  final MapType currentMapType;
  final Completer<GoogleMapController> controller; // Completer olarak tanımlandı
  final Offset fabPosition;
  final String? polylineName;
  final double? distance;
  final VoidCallback onSelectPointsButtonPressed;
  final VoidCallback onMapTypeButtonPressed;

  const MapStack({
    Key? key,
    required this.initialCameraPosition,
    required this.polylines,
    required this.markers,
    required this.currentMapType,
    required this.controller,
    required this.fabPosition,
    required this.polylineName,
    required this.distance,
    required this.onSelectPointsButtonPressed,
    required this.onMapTypeButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FractionallySizedBox(
          heightFactor: 0.7,
          child: GoogleMap(
            polylines: Set<Polyline>.of(polylines.values),
            markers: Set<Marker>.of(markers.values),
            myLocationButtonEnabled: true,
            mapType: currentMapType,
            initialCameraPosition: initialCameraPosition,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController mapController) {
              controller.complete(mapController); // Completer'ı burada tamamlayın
            },
          ),
        ),
        Positioned(
          bottom: 150,
          left: 10,
          child: ElevatedButton(
            onPressed: onSelectPointsButtonPressed,
            child: Text('Başlangıç ve Bitiş Noktalarını Seç'),
          ),
        ),
        Positioned(
          left: fabPosition.dx,
          top: fabPosition.dy,
          child: Draggable(
            feedback: FloatingActionButton(
              onPressed: null,
              child: Icon(Icons.map),
              backgroundColor: Colors.orange,
            ),
            childWhenDragging: Container(),
            onDraggableCanceled: (velocity, offset) {
              // FAB pozisyonunu güncelle
            },
            child: FloatingActionButton(
              onPressed: onMapTypeButtonPressed,
              child: Icon(Icons.map),
              backgroundColor: Colors.orange,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (polylineName != null)
                  Text(
                    'Çizgi Adı: $polylineName',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                if (distance != null)
                  Text(
                    'Mesafe: ${distance!.toStringAsFixed(2)} km',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
