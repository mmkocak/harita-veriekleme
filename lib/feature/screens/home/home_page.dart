
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class HomePage extends StatefulWidget {
   HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
  
}
double _originLatitude = 38.4382955939104; // Başlangıç noktası enlemi
double _originLongitude = 27.141358956227965; // Başlangıç noktası boylamı
double _destLatitude = 38.422733197746986; // Bitiş noktası enlemi
double _destLongitude = 27.129490953156576; // Bitiş noktası boylamı
class _HomePageState extends State<HomePage> {
    PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  MapType _currentMapType = MapType.normal;
  late GoogleMapController _controller;
  int _polylineIdCounter = 1;
  int _markerIdCounter = 1;

  Offset _fabPosition =
      Offset(20, 20); // FloatingActionButton başlangıç pozisyonu

  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(_originLatitude, _originLongitude),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
       ),
       body: Stack(
        children: [
          GoogleMap(
             polylines: Set<Polyline>.of(polylines.values),
            markers: Set<Marker>.of(markers.values),
            myLocationButtonEnabled: true,
            mapType: _currentMapType,
            initialCameraPosition: _initialCameraPosition,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          ),
          Positioned(
             bottom: 50,
            left: 10,
            child: ElevatedButton(
              onPressed: _onSelectPointsButtonPressed,
              child: Text('Başlangıç ve Bitiş Noktalarını Seç'),
            ),
          ),
          Positioned(
            left: _fabPosition.dx,
            top: _fabPosition.dy,
            child: Draggable(
              feedback: FloatingActionButton(
                onPressed: null,
                child: Icon(Icons.map),
                backgroundColor: Colors.orange,
              ),
              childWhenDragging: Container(),
              onDraggableCanceled: (velocity, offset) {
                setState(() {
                  _fabPosition = offset;
                });
              },
              child: FloatingActionButton(
                onPressed: _onMapTypeButtonPressed,
                child: Icon(Icons.map),
                backgroundColor: Colors.orange,
              ),
            ),
          ),
        ],
       ),
      ),
    );
  }
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
    void _onSelectPointsButtonPressed() async {
    LatLng? origin = await _selectPoint(context, 'Başlangıç Noktasını Seçin');
    if (origin == null) return;

    LatLng? destination = await _selectPoint(context, 'Bitiş Noktasını Seçin');
    if (destination == null) return;

    String? polylineName = await _getPolylineName(context);
    if (polylineName == null || polylineName.isEmpty) return;

    Color? polylineColor = await _getPolylineColor(context);
    if (polylineColor == null) return;

    setState(() {
      _originLatitude = origin.latitude;
      _originLongitude = origin.longitude;
      _destLatitude = destination.latitude;
      _destLongitude = destination.longitude;
    });

    _getPolyline(polylineName, polylineColor);
  }
  Future<LatLng?> _selectPoint(BuildContext context, String title) async {
    LatLng? selectedPoint;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: GoogleMap(
            initialCameraPosition: _initialCameraPosition,
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
   Future<String?> _getPolylineName(BuildContext context) async {
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
  Future<Color?> _getPolylineColor(BuildContext context) async {
    Color? selectedColor;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Çizgi Rengi Seçin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.circle, color: Colors.red),
              title: Text('Kırmızı'),
              onTap: () {
                selectedColor = Colors.red;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.circle, color: Colors.green),
              title: Text('Yeşil'),
              onTap: () {
                selectedColor = Colors.green;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.circle, color: Colors.blue),
              title: Text('Mavi'),
              onTap: () {
                selectedColor = Colors.blue;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.circle, color: Colors.yellow),
              title: Text('Sarı'),
              onTap: () {
                selectedColor = Colors.yellow;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.circle, color: Colors.orange),
              title: Text('Turuncu'),
              onTap: () {
                selectedColor = Colors.orange;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.circle, color: Colors.purple),
              title: Text('Mor'),
              onTap: () {
                selectedColor = Colors.purple;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.circle, color: Colors.pink),
              title: Text('Pembe'),
              onTap: () {
                selectedColor = Colors.pink;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.circle, color: Colors.brown),
              title: Text('Kahverengi'),
              onTap: () {
                selectedColor = Colors.brown;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.circle, color: Colors.grey),
              title: Text('Gri'),
              onTap: () {
                selectedColor = Colors.grey;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
    return selectedColor;
  }
 void _getPolyline(String polylineName, Color polylineColor) async {
    List<LatLng> polylineCoordinates = [];

    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          request: PolylineRequest(
              origin: PointLatLng(_originLatitude, _originLongitude),
              destination: PointLatLng(_destLatitude, _destLongitude),
              mode: TravelMode.driving),
          googleApiKey: "API_KEY");

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print("Hata: ${result.errorMessage}");
      }

      _addPolyline(polylineCoordinates, polylineName, polylineColor);
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }
 void _addPolyline(List<LatLng> polylineCoordinates, String polylineName,
      Color polylineColor) {
    final PolylineId polylineId = PolylineId("polyline_$_polylineIdCounter");
    _polylineIdCounter++;

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      color: polylineColor,
      points: polylineCoordinates,
      width: 8,
      onTap: () {
        _showPolylineInfo(polylineName);
      },
    );

    polylines[polylineId] = polyline;

    // Başlangıç noktası markerı
    final MarkerId startMarkerId = MarkerId("start_marker_$_markerIdCounter");
    _markerIdCounter++;
    final Marker startMarker = Marker(
      markerId: startMarkerId,
      position: polylineCoordinates.first,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: "Başlangıç Noktası"),
    );
    markers[startMarkerId] = startMarker;

    // Bitiş noktası markerı
    final MarkerId endMarkerId = MarkerId("end_marker_$_markerIdCounter");
    _markerIdCounter++;
    final Marker endMarker = Marker(
      markerId: endMarkerId,
      position: polylineCoordinates.last,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: "Bitiş Noktası"),
    );
    markers[endMarkerId] = endMarker;

    setState(() {});
  }
  void _showPolylineInfo(String polylineName) {
    double totalDistance = _calculateTotalDistance();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(polylineName),
        content: Text(
            'Başlangıç ve Bitiş Noktaları Arasındaki Mesafe: ${totalDistance.toStringAsFixed(2)} km'),
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
  }
    double _calculateTotalDistance() {
    double totalDistance = 0.0;
    for (int i = 0; i < polylines.length; i++) {
      Polyline polyline = polylines.values.elementAt(i);
      for (int j = 0; j < polyline.points.length - 1; j++) {
        totalDistance += Geolocator.distanceBetween(
          polyline.points[j].latitude,
          polyline.points[j].longitude,
          polyline.points[j + 1].latitude,
          polyline.points[j + 1].longitude,
        );
      }
    }
    return totalDistance / 1000; // Mesafeyi km olarak döndürür
  }
}
